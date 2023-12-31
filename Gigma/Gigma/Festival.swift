//
//  Festival.swift
//  Gigma
//
//  Created by Nada Struharova on 6/1/23.
//

import Foundation
import CoreLocation

@objc class Festival : NSObject, Identifiable, Codable {
    var festivalID: Int?
    var displayName: String?
    var centre: CodableCoordinate
    var height: Double
    var width: Double
    var stages: [String : CodableCoordinate]?
    var toilets: [CodableCoordinate]?
    var water: [CodableCoordinate]?
    
    init(festivalID: Int? = nil, displayName: String? = nil, centre: CodableCoordinate = CodableCoordinate(latitude: 51.5124801, longitude: -0.2182141), height: Double, width: Double, stages: [String : CodableCoordinate]? = nil, toilets: [CodableCoordinate]? = nil, water: [CodableCoordinate]? = nil) {
        self.festivalID = festivalID
        self.displayName = displayName
        self.centre = centre
        self.height = height
        self.width = width
        self.stages = stages
        self.toilets = toilets
        self.water = water
    }
}

@objc class CodableCoordinate : NSObject, Codable {
    
    var latitude: Double
    var longitude: Double

    func toCLCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

}
