//
//  Festival.swift
//  Gigma
//
//  Created by Nada Struharova on 6/1/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

struct Festival: Identifiable, Codable {
    @DocumentID var id: String?
    var centre: GeoPoint?
    var height: Double
    var width: Double
    var stages: [String: GeoPoint]?
    var toilets: [GeoPoint]?
    var water: [GeoPoint]?
}
