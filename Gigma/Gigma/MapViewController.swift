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

class MapViewController : UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var data: DataBaseDriver
    var bluetooth: BluetoothDriver
    var mapCache: MapCache?
    let locationManager = CLLocationManager()
    var festival: Festival?
    var managedObjectContext: NSManagedObjectContext?
    var userLocation: CLLocationCoordinate2D?
    
    //constants to use for marker drawings
    let SIDE: Double = 17.5
    let MARKER_MUL: Double = 1.3
    var MARKER_SIDE: Double
    
    //Custom user pins
//    var isCustomMarkers: Bool
    //var userMarkers: [UserMarker] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        data = appDelegate.data
        bluetooth = appDelegate.bluetoothDriver
        self.MARKER_SIDE = SIDE * MARKER_MUL
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        data = appDelegate.data
        bluetooth = appDelegate.bluetoothDriver
        self.MARKER_SIDE = SIDE * MARKER_MUL
        super.init(coder: coder)
    }
    
    @available(iOS 13.0, *)
    func initLongPressGestureRecogniser() {
        let lpgr = UILongPressGestureRecognizer(target: self, action:  #selector(addUserMarker))
        mapView.addGestureRecognizer(lpgr)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        self.locationManager.requestAlwaysAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
        
        mapView.delegate = self
        let festivalID = UserDefaults.standard.integer(forKey: "FestivalIDSet")
        let config = MapCacheConfig(withUrlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
        mapCache = MapCache(withConfig: config)
        mapView.showsUserLocation = true;
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showFriends()
        renderCustomMarkers()
        checkPrefs()
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
        friends!.forEach {friend in
            let marker = MKPointAnnotation()
            marker.title = (friend as! Friend).friendName
            marker.subtitle = "Friend"
            // FIX -- marker.coordinate = bluetooth.getLocation(uuid: (friend as! Friend).deviceID! as NSUUID).toCLCoordinate()
            mapView.addAnnotation(marker)
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
    
    //TODO: get the colour from CORE DATA
    func getFriendColour(name: String) -> UIColor {
        return .red
    }
    
    /* Select the image to display and how it is displayed */
    func imageSelector(annotationView: MKAnnotationView, annotation: MKAnnotation)  {
        switch annotation.subtitle {
            case "Custom Marker":
                let custMarker = annotation as! UserMarker
                annotationView.image = makeCustomMarker(shape: custMarker.icon, colour: custMarker.colour)
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
    
    @objc func addUserMarker(recogniser: UIGestureRecognizer) {
        if (recogniser.state != UIGestureRecognizer.State.began) {return}
        
        // gets the location of the touch and convert to coordinate
        let touchPoint = recogniser.location(in: mapView)
        let coord = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
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
        let newMarker = UserMarker.init(title: "User Marker", coordinate: coord, colour: .blue, info: "info")
        mapView.addAnnotation(newMarker)
    }
}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        self.userLocation = location
    }
}

extension MapViewController : PopoverDelegate {
    func popoverDidDisappear() {
        self.checkPrefs()
    }
}

extension NSNotification.Name {
    static let clearCache = Notification.Name("clear-cache")

}
