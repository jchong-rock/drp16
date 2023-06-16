//
//  UserMarker.swift
//  Gigma
//
//  Created by kup21 on 13/06/2023.
//

import Foundation
import MapKit

@objc protocol RemoveMarkerDelegate {
    func removeMarker(marker: MKAnnotation)
}

class UserMarker : NSObject, MKAnnotation {
    var title: String?
    var subtitle: String? = "Custom Marker"
    var coordinate: CLLocationCoordinate2D
    var colour: UIColor
    var info: String
    var icon: String // name of the system icon to display
    var delegate: RemoveMarkerDelegate
    
    
    init(title: String, coordinate: CLLocationCoordinate2D, icon: String = "pin.circle.fill", colour: UIColor = .red, info: String = "", delegate: RemoveMarkerDelegate) {
        self.title = title
        self.coordinate = coordinate
        self.colour = colour
        self.info = info
        self.icon = icon
        self.delegate = delegate
    }
    
    @objc func removeAnnotationOnLongPress(_ sender: MKAnnotation?) {
        print("called it")
        if (sender != nil) {
            delegate.removeMarker(marker:self)
        }
    }
}
