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
    
    var data: DataBaseDriver = PostgreSQLDriver()
    var bluetooth: BluetoothDriver = Bluetoother()
    var mapCache: MapCache?
    let locationManager = CLLocationManager()
    var festival: Festival?
    var managedObjectContext: NSManagedObjectContext?
    
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

        let errorLocation = CLLocationCoordinate2DMake(51.5124801, -0.2182141)
        let errorRegion = MKCoordinateRegion(center: mapView.userLocation.location?.coordinate ?? errorLocation, latitudinalMeters: 200, longitudinalMeters: 200)
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
            marker.coordinate = bluetooth.getLocation(uuid: (friend as! Friend).deviceID! as NSUUID).toCLCoordinate()
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
}

// not yet working -- get user's location
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
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
