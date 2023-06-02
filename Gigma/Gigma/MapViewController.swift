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
    
    var data: DataBaseDriver = FestivalData.init()
    var mapCache: MapCache?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let config = MapCacheConfig(withUrlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
        mapCache = MapCache(withConfig: config)
        let festivalName = UserDefaults.standard.string(forKey: "FestivalIsSet")
        let festival = data.getFestival(name: festivalName! as String)
        let centre = festival.centre!.toCLCoordinate()
        let width = festival.width
        let height = festival.height
        let coords = MKCoordinateRegion(center: centre, latitudinalMeters: width, longitudinalMeters: height)
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
