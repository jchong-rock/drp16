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

class MapViewController : UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var data: DataBaseDriver = PostgreSQLDriver()
    var mapCache: MapCache?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let festivalName = UserDefaults.standard.string(forKey: "FestivalIsSet")
        let config = MapCacheConfig(withUrlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
        mapCache = MapCache(withConfig: config)
        mapView.showsUserLocation = true;

        let errorLocation = CLLocationCoordinate2DMake(51.5124801, -0.2182141)
        let errorRegion = MKCoordinateRegion(center: mapView.userLocation.location?.coordinate ?? errorLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(errorRegion, animated: true)
        
        if (festivalName != "Unknown Festival") {
            let connectionSuccess = data.connect()
            if connectionSuccess {
                let festival = data.getFestival(name: festivalName! as String)
                let centre = festival.centre.toCLCoordinate()
                let width = festival.width
                let height = festival.height
                let coords = MKCoordinateRegion(center: centre, latitudinalMeters: width, longitudinalMeters: height)
                mapView.setRegion(coords, animated: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Connection to database failed.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        mapView.useCache(mapCache!)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(clearCache), name: NSNotification.Name.clearCache, object: nil)
    }
    
    @objc func clearCache() {
        mapCache?.clear() {
            //print("cache cleared")
        }
    }

}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            return mapView.mapCacheRenderer(forOverlay: overlay)
        }
}

extension NSNotification.Name {
    static let clearCache = Notification.Name("clear-cache")
}
