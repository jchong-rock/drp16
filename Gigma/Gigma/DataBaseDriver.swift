//
//  DataBaseDriver.swift
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

import Foundation
import CoreLocation

@objc protocol DataBaseDriver {
    func getFestivals() -> [NSString]
    func getLocationCentre(festival: NSString) -> CLLocationCoordinate2D
    func getPointsOfInterest(festival: NSString) -> [CLLocationCoordinate2D]
}

@objc class FakeData : NSObject, DataBaseDriver {
    func getFestivals() -> [NSString] {
        return ["Jaketown", "Bjorna", "Wireless", "Kagan"]
    }
    
    func getLocationCentre(festival: NSString) -> CLLocationCoordinate2D {
        if (festival == "Bjorna") {
            return CLLocationCoordinate2DMake(53.807220, -1.530743)
        }
        if (festival == "Kagan") {
            return CLLocationCoordinate2DMake(53.9639935, -1.0872748)
        }
        return CLLocationCoordinate2DMake(51.499043, -0.179375)
    }
    func getPointsOfInterest(festival: NSString) -> [CLLocationCoordinate2D] {
        return [CLLocationCoordinate2DMake(51.499043, -0.179375)]
    }
}
