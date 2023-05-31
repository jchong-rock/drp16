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

class MapViewController : UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let config = MapCacheConfig(withUrlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
        let mapCache = MapCache(withConfig: config)
        let coords = MKCoordinateRegion(center: CLLocationCoordinate2DMake(51.499043, -0.179375), latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(coords, animated: true)
        mapView.useCache(mapCache)
    }

}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            return mapView.mapCacheRenderer(forOverlay: overlay)
        }
}
