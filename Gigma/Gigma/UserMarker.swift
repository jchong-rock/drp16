//
//  UserMarker.swift
//  Gigma
//
//  Created by kup21 on 13/06/2023.
//

import Foundation
import MapKit

class UserMarker : NSObject, MKAnnotation {
    var title: String?
    var subtitle: String? = "Custom Marker"
    var coordinate: CLLocationCoordinate2D
    var colour: UIColor
    var info: String
    var icon: String // name of the system icon to display
    
    
    init(title: String, coordinate: CLLocationCoordinate2D, icon: String = "person.circle.fill", colour: UIColor = .red, info: String = "") {
        self.title = title
        self.coordinate = coordinate
        self.colour = colour
        self.info = info
        self.icon = icon
    }
}
