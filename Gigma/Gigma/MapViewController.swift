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
    @IBOutlet weak var settingsButton: UIButton!
    
    var data: DataBaseDriver
    var multipeer: MultipeerDriver
    var mapCache: MapCache?
    let locationManager = CLLocationManager()
    var festival: Festival?
    var managedObjectContext: NSManagedObjectContext?
    var userLocation: CLLocationCoordinate2D?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        data = appDelegate.data
        multipeer = appDelegate.multipeerDriver
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        data = appDelegate.data
        multipeer = appDelegate.multipeerDriver
        super.init(coder: coder)
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
        mapView.showsUserLocation = true
        
        
        guard let location = self.locationManager.location?.coordinate else { return }
        self.userLocation = location

        let errorLocation = CLLocationCoordinate2DMake(51.5124801, -0.2182141)
        let errorRegion = MKCoordinateRegion(center: userLocation ?? errorLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(errorRegion, animated: true)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsButton.setTitle("", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showFriends()
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
                default:
                    MainViewController.showErrorPopup(self, withMessage: "Setting does not exist.")
            }
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
        print(annotation.title)
        print(annotation.subtitle)
        
        if annotation.title == "Water Source" {
            annotationView!.image = makeImage(shape: "drop.fill", colour: .brown)
        }
        if annotation.title == "Toilet" {
            
            print("Toilet")
            annotationView!.image = makeImage(shape: "toilet.fill", colour: .blue)
        }
        if annotation.subtitle == "Stage" {
            print("here")
            annotationView!.image = makeImage(shape: "music.mic", colour: .systemPink)
        }
        if annotation.subtitle == "Friend" {
            let friendColour = getFriendColour(name: annotation.title!!)
            annotationView!.image = makeImage(shape: "person.fill", colour: friendColour)
        }
        return annotationView
    }
    
    //TODO: get the colour from CORE DATA
    func getFriendColour(name: String) -> UIColor {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
        let friends = MainViewController.getFriendsFrom(moc)
        for friend in friends! {
            if (friend as! Friend).friendName == name {
                return ColourConverter.toColour(UInt64((friend as! Friend).colour))
            }
        }
        
        return .red
    }
    func makeImage(shape: String, colour: UIColor) -> UIImage {
        let icon = UIImage(systemName: shape)!.withTintColor(.white) // draw the icon in white
        let SIDE: Double = 17.5             // CHANGE SIZE HERE <------------
        let MARKER_SIDE = Double(SIDE) * 1.3
        
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
