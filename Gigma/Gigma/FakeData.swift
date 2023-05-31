//
//  FakeData.swift
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

import Foundation
import CoreLocation

@objc protocol DataBaseDownloader {
    func getFestivals() -> [NSString]
    func getLocationCentre(festival: NSString) -> CLLocationCoordinate2D
    func getPointsOfInterest(festival: NSString) -> [CLLocationCoordinate2D]
}

@objc class FakeData : NSObject, DataBaseDownloader {
    func getFestivals() -> [NSString] {
        return ["Jaketown", "Leeds", "Wireless"]
    }
    
    func getLocationCentre(festival: NSString) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(51.499043, -0.179375)
    }
    func getPointsOfInterest(festival: NSString) -> [CLLocationCoordinate2D] {
        return [CLLocationCoordinate2DMake(51.499043, -0.179375)]
    }
}
