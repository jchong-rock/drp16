//
//  DataBaseDriver.swift
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

// CONFLICTS

import Foundation
import CoreLocation
import Firebase

@objc protocol DataBaseDriver {
    func initFestivals()
    func getFestivalList() -> [String]
    func getFestival(name: String) -> Festival
}

// // extract coordinates from centre GeoPoint
// CLLocationCoordinate2D(latitude: Festival.centre.latitude,
//                      longitude: Festival.centre.longitude)
