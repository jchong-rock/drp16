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
    
    var data: DataBaseDriver = FakeData.init()
    var mapCache: MapCache?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let config = MapCacheConfig(withUrlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
        mapCache = MapCache(withConfig: config)
        let festival = UserDefaults.standard.string(forKey: "FestivalIsSet")
        let centre = data.getLocationCentre(festival: festival! as NSString)
        let coords = MKCoordinateRegion(center: centre, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(coords, animated: true)
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
