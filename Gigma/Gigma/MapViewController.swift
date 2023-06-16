//
//  MapViewController.swift
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

import Foundation
import UIKit
import MapCache
import MapKit
import NotificationCenter
import CoreData
import AudioToolbox

class MapViewController : UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var beaconButton: UIButton!
    
    var data: DataBaseDriver
    var multipeer: MultipeerDriver
    var mapCache: MapCache?
    let locationManager = CLLocationManager()
    var festival: Festival?
    var managedObjectContext: NSManagedObjectContext?
    var userLocation: CLLocationCoordinate2D?
    var friendMarkers: [Friend : MKPointAnnotation] = [:]
    @objc public var currentFriend: Friend?
    
    var headingImageView: UIImageView?
    var userHeading: CLLocationDirection?
    
    // CustomMarkerAdder delegate
//    var custMarkAdderDelegate: AddCustomMarkerDelegate
    
    //constants to use for marker drawings
    let SIDE: Double = 17.5
    let MARKER_MUL: Double = 1.3
    var MARKER_SIDE: Double
    
    //Custom user pins
    var lastCustomColour: UIColor = .red
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        data = appDelegate.data
        multipeer = appDelegate.multipeerDriver
        self.MARKER_SIDE = SIDE * MARKER_MUL
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        data = appDelegate.data
        multipeer = appDelegate.multipeerDriver
        self.MARKER_SIDE = SIDE * MARKER_MUL
        super.init(coder: coder)
    }
    
    @available(iOS 13.0, *)
    func initLongPressGestureRecogniser() {
        let lpgr = UILongPressGestureRecognizer(target: self, action:  #selector(addCustomMarker))
        mapView.addGestureRecognizer(lpgr)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        self.multipeer.updateLocationDelegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
                self.locationManager.startUpdatingHeading()
            }
        }
        
        mapView.delegate = self
        let festivalID = UserDefaults.standard.integer(forKey: "FestivalIDSet")
        let config = MapCacheConfig(withUrlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
        mapCache = MapCache(withConfig: config)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        
        guard let location = self.locationManager.location?.coordinate else { return }
        self.userLocation = location

        let errorLocation = CLLocationCoordinate2DMake(51.5124801, -0.2182141)
        let errorRegion = MKCoordinateRegion(center: userLocation ?? errorLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(errorRegion, animated: true)
        if #available(iOS 13.0, *) {
            initLongPressGestureRecogniser()
        }
        
        if (festivalID != 0) {
            let connectionSuccess = data.connect()
            if connectionSuccess {
                festival = data.getFestival(festivalID: festivalID as Int)
                let centre = festival!.centre.toCLCoordinate()
                let width = festival!.width
                let height = festival!.height
                let coords = MKCoordinateRegion(center: centre, latitudinalMeters: width, longitudinalMeters: height)
                mapView.setRegion(coords, animated: true)
            } else {
                MainViewController.showErrorPopup(self, withMessage: "Connection to database failed.")
            }
            data.close()
        }
        
        
        mapView.useCache(mapCache!)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(clearCache), name: NSNotification.Name.clearCache, object: nil)
        print("didload")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsButton.setTitle("", for: .normal)
        beaconButton.setTitle("", for: .normal)
        print("willappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showFriends()
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentViewController = self
        if (currentFriend != nil) {
            let friendLocation = MainViewController.getFriendLocation(currentFriend)
            if (friendLocation.latitude != 0 || friendLocation.longitude != 0) {
                let errorRegion = MKCoordinateRegion(center: friendLocation, latitudinalMeters: 200, longitudinalMeters: 200)
                mapView.setRegion(errorRegion, animated: true)
            }
            currentFriend = nil
        }
        renderCustomMarkers()
        checkPrefs()
        print("didappear")
    }
    
    func checkPrefs() {
        let prefs = MainViewController.prefsList(self)
        prefs!.forEach {p in
            let pref = p as! MapSetting
            switch pref.prefName {
                case "Show stages":
                    pref.enabled ? showStages() : hideStages()
                case "Show toilets":
                    pref.enabled ? showToilets() : hideToilets()
                case "Show water sources":
                    pref.enabled ? showWater() : hideWater()
//                case "Show custom markers":
//                    pref.enabled ? showCustomMarkers() : hideCustomMarkers()
                default:
                    MainViewController.showErrorPopup(self, withMessage: "Setting does not exist.")
            }
        }
    }
    
    @IBAction func alertBeaconPopUp(_ sender: AnyObject) {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let alertController = UIAlertController(title: "Alert Friends", message: "Do you want to ping all your friends the location?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okaAction = UIAlertAction(title: "Send", style: .default) { _ in
            self.multipeer.beaconLocation()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okaAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    // TODO: Not working! -> FIX
    @objc func renderCustomMarkers() {
        guard let markers = MainViewController.getCustomMarkers(from: managedObjectContext) else {
                return
        }
        print("markers")
        print(markers)
        for marker in markers {
            let customMarker = marker as! CustomMarker
            let userMarker = UserMarker(
                title: customMarker.name!,
                coordinate: CLLocationCoordinate2DMake(
                    customMarker.latitude,
                    customMarker.longitude
                ),
                colour: ColourConverter.toColour(customMarker.colour),
                info: "") //TODO: add info field to core data
            mapView.addAnnotation(userMarker)
        }
    }
    
    @objc func showFriends() {
        let annotationsToRemove = mapView.annotations.filter { marker in
            marker.subtitle == "Friend"
        }
        
        let friends = MainViewController.getFriendsFrom(managedObjectContext)
        mapView.removeAnnotations( annotationsToRemove )
        friendMarkers = [:]
        friends!.forEach {friend in
            let marker = MKPointAnnotation()
            marker.title = (friend as! Friend).friendName
            marker.subtitle = "Friend"
            // FIX -- marker.coordinate = bluetooth.getLocation(uuid: (friend as! Friend).deviceID! as NSUUID).toCLCoordinate()
            mapView.addAnnotation(marker)
            friendMarkers[friend as! Friend] = marker
        }
    }
    
    @objc func showStages() {
        festival?.stages?.forEach {name, loc in
            let marker = MKPointAnnotation()
            marker.title = name
            marker.subtitle = "Stage"
            marker.coordinate = loc.toCLCoordinate()
            mapView.addAnnotation(marker)
        }
    }
    
    @objc func hideStages() {
        let annotationsToRemove = mapView.annotations.filter { marker in
            marker.subtitle == "Stage"
        }
        mapView.removeAnnotations( annotationsToRemove )
    }
    
    @objc func showToilets() {
        festival?.toilets?.forEach {loc in
            let marker = MKPointAnnotation()
            marker.title = "Toilet"
            marker.coordinate = loc.toCLCoordinate()
            mapView.addAnnotation(marker)
        }
    }
    
    @objc func hideToilets() {
        let annotationsToRemove = mapView.annotations.filter { marker in
            marker.title == "Toilet"
        }
        mapView.removeAnnotations( annotationsToRemove )
    }
    
    @objc func showWater() {
        festival?.water?.forEach {loc in
            let marker = MKPointAnnotation()
            marker.title = "Water Source"
            marker.coordinate = loc.toCLCoordinate()
            mapView.addAnnotation(marker)
        }
    }
    
    @objc func hideWater() {
        let annotationsToRemove = mapView.annotations.filter { marker in
            marker.title == "Water Source"
        }
        mapView.removeAnnotations( annotationsToRemove )
    }
    
    @objc func clearCache() {
        mapCache?.clear() {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSettingsSegue" {
            if let destinationViewController = segue.destination as? MapSettingsViewController {
                destinationViewController.delegate = self
            }
        }
    }
}

extension MapViewController : UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let vc = viewController as! CustomColourViewController
        let coord = CLLocationCoordinate2D(latitude: vc.locationLatitude as! Double, longitude: vc.locationLongitude as! Double)
        let titleIsValid = self.addNewMarker(name: vc.markerName, coord: coord, colour: vc.selectedColor)
        if !titleIsValid {
            actuallyAddMarker(coord: coord)
        }
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        lastCustomColour = viewController.selectedColor
    }
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        
    }
}

@available(iOS 13.0, *)
extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return mapView.mapCacheRenderer(forOverlay: overlay)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customPin")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customPin")
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        imageSelector(annotationView: annotationView!, annotation: annotation)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if views.last?.annotation is MKUserLocation {
            addHeadingView(toAnnotationView: views.last!)
        }
    }
    
    func addHeadingView(toAnnotationView annotationView: MKAnnotationView){
        if headingImageView == nil {
            let image = UIImage(systemName: "arrow.forward")
            headingImageView = UIImageView(image: image)
            headingImageView!.frame = CGRect(x: (annotationView.frame.size.width - image!.size.width)/2, y: (annotationView.frame.size.height - image!.size.height)/2, width: image!.size.width, height: image!.size.height)
            annotationView.insertSubview(headingImageView!, at: 0)
            headingImageView!.isHidden = true
        }
    }
    
    //TODO: get the colour from CORE DATA
    func getFriendColour(name: String) -> UIColor {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
        let friends = MainViewController.getFriendsFrom(moc)
        for friend in friends! {
            if (friend as! Friend).friendName == name {
                return ColourConverter.toColour(((friend as! Friend).colour))
            }
        }
        return .red
    }
    
    /* Select the image to display and how it is displayed */
    func imageSelector(annotationView: MKAnnotationView, annotation: MKAnnotation)  {
        switch annotation.subtitle {
            case "Custom Marker":
                let userMarker = annotation as! UserMarker
                annotationView.image = makeCustomMarker(shape: userMarker.icon, colour: userMarker.colour)
            case "Stage":
                annotationView.image = makePredefMarker(shape: "music.mic", colour: .systemPink)
            case "Friend":
                let friendColour = getFriendColour(name: annotation.title!!)
                annotationView.image = makePredefMarker(shape: "person.fill", colour: friendColour)
            default:
                switch annotation.title {
                    case "Toilet":
                        annotationView.image = makePredefMarker(shape: "toilet.fill", colour: .blue)
                    case "Water Source":
                        annotationView.image = makePredefMarker(shape: "drop.fill", colour: .brown)
                    // no other case
                    default:
                        print("Error -- can't reach here")
                }
        }
    }
    func makeCustomMarker(shape: String, colour: UIColor) -> UIImage {
        let icon = UIImage(systemName: shape)!.withTintColor(colour)
        let size = CGSize(width: MARKER_SIDE, height: MARKER_SIDE)
        let iconRect = CGRect(origin: .zero, size: size)
        
        return UIGraphicsImageRenderer(size: size).image {
            _ in
            colour.setFill()
            icon.draw(in: iconRect)
        }
    }
    func makePredefMarker(shape: String, colour: UIColor) -> UIImage {
        let icon = UIImage(systemName: shape)!.withTintColor(.white) // draw the icon in white
        let SIDE: Double = 17.5             // CHANGE SIZE HERE <------------
        
        
        let iconSize = CGSize(width: SIDE, height: SIDE)
        let markerSize = CGSize(width: MARKER_SIDE, height: MARKER_SIDE)
        
        // Centre the icon to the marer below
        let iconOffset = (MARKER_SIDE - SIDE) / 2
        let iconCentre = CGPointApplyAffineTransform(
            .zero,
            CGAffineTransform(translationX: CGFloat(iconOffset), y: CGFloat(iconOffset))
        )
        
        // markerCentre is just (0,0) assuming this is centre of the point
        let markerCentre = CGPointApplyAffineTransform(
            .zero,
            CGAffineTransform(translationX: 0, y: 0)
        )
        
        // rectangles to draw
        let iconRect = CGRect(origin: iconCentre, size: iconSize)
        let markerRect = CGRect(origin: markerCentre, size: markerSize)
        let marker = UIBezierPath(ovalIn: markerRect)
        marker.lineWidth = 1
        
        
        return UIGraphicsImageRenderer(size: markerSize).image {
            _ in
            colour.setFill()
            marker.fill()
            icon.draw(in: iconRect)
        }
    }
    
    //TODO: ad colour and icon?
    func addNewMarker(name: String?, coord: CLLocationCoordinate2D, colour: UIColor) -> Bool {
        if (name == nil) {return false}
            
        for marker in MainViewController.getCustomMarkers(from: managedObjectContext!) {
            let custMarker = marker as! CustomMarker
            if (name == custMarker.name) {
                return false
            }
        }
        let newMarker = NSEntityDescription.insertNewObject(forEntityName: "CustomMarker", into: managedObjectContext!)
        let newCustMarker = newMarker as! CustomMarker
        newCustMarker.name = name!
        newCustMarker.latitude = coord.latitude
        newCustMarker.longitude = coord.longitude
        newCustMarker.colour = ColourConverter.toHex(colour)
        //TODO: colour and icon?
        
        do {
            print("saving marker")
            try managedObjectContext!.save()
            let newMarker = UserMarker.init(title: name!, coordinate: coord, colour: colour, info: "info")
            self.mapView.addAnnotation(newMarker)
            return true
        } catch {
            return false
        }
        
        
    }
    
    @objc func addCustomMarker(recogniser: UIGestureRecognizer) {
        if (recogniser.state != UIGestureRecognizer.State.began) {return}
        let touchPoint = recogniser.location(in: mapView)
        let coord = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        actuallyAddMarker(coord: coord)
    }
    @objc func actuallyAddMarker(coord: CLLocationCoordinate2D) {
        //create the adder view
        // Create the alert controller
        let alertController = UIAlertController(title: "New Custom Marker", message: nil, preferredStyle: .alert)

        // Add a text field to the alert controller
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        // gets the location of the touch and convert to coordinate
        
        //custAddView.setCoordinate(coord)
        //self.presentedViewController(custAddView, sender: self)
//        present(custAddView, animated: true, completion: nil
        
        // Create an "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Handle the user's input
            if let textField = alertController.textFields?.first {
                let enteredText = textField.text
                // Do something with the entered text
                print("Entered text: \(enteredText ?? "")")
                let colourPicker = CustomColourViewController()
                colourPicker.delegate = self
                colourPicker.markerName = enteredText
                colourPicker.locationLatitude = coord.latitude as NSNumber
                colourPicker.locationLongitude = coord.longitude as NSNumber
                self.present(colourPicker, animated: true)
                
                
//                var title: String
//                if (titleIsValid) {
//                    title = enteredText!
//                } else {
//                    title = "Untitled"
//                }
//
//                let newMarker = UserMarker.init(title: title, coordinate: coord, colour: .blue, info: "info")
//                self.mapView.addAnnotation(newMarker)
            }
        }

        // Create a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            self.lastCustomColour = .red
        }
        // Add the actions to the alert controller
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        // Colour initially red
        //alertController.setValue(UIColor.red, forKey: "Select Colour")
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
        
        
        
        //save in core data so that these are persistent
        // now done in AddCustomMarkerViewController
//        let coreMarker = NSEntityDescription.insertNewObject(forEntityName: "CustomMarker", into: managedObjectContext!) as! CustomMarker
//
//        coreMarker.name = "User Marker"                    //TODO: Change -> needs to be dyanmic
//        coreMarker.colour = ColourConverter.toHex(.blue)  //TODO: Change -> needs to be dynamic
//        coreMarker.latitude = coord.latitude
//        coreMarker.longitude = coord.longitude
        
//        do {
//            try managedObjectContext!.save()
//        } catch {} // I don't care about errors
        
        //TODO: call the view controller to handle the popup
    }
    
    func checkTitle(_ title: String?) -> Bool {
        if (title == nil) {
            return false
        }
        return true
    }
}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        self.userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading){
        if newHeading.headingAccuracy < 0 {return}
        
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        userHeading = heading
        updateHeadingRotation()
    }
    
    func updateHeadingRotation() {
        if let heading = userHeading,
           let headingImageView = headingImageView{
            
            headingImageView.isHidden = false
            let rotation = CGFloat(heading/180 * Double.pi)
            headingImageView.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
}

extension MapViewController : PopoverDelegate {
    func popoverDidDisappear() {
        self.checkPrefs()
    }
}

extension MapViewController : UpdateLocationDelegate {
    func getUserLocation() -> CLLocationCoordinate2D {
        return userLocation ?? CLLocationCoordinate2D(latitude: 51.512575123209686, longitude: -0.21905022397458035)
    }
    
    func setLatitude(_ latVal: Double, andLongitude longVal: Double, of friend: Friend) {
        print("coords", latVal, longVal)
        friendMarkers[friend]?.coordinate = CLLocationCoordinate2D(latitude: latVal, longitude: longVal)
    }
}

extension NSNotification.Name {
    static let clearCache = Notification.Name("clear-cache")

}
