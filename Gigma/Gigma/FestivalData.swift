//
//  FestivalData.swift
//  Gigma
//
//  Created by Nada Struharova on 6/1/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

class FestivalData : ObservableObject, DataBaseDownloader {
    
    @Published var festivals = [Festival]()
    @Published var festival = Festival(id: "", centre: nil, height: 0, width: 0, stages: [:], toilets: [], water: [])
    
    func getFestivalList() -> [String] {
        // Get reference to database
        let db = Firestore.firestore()
        
        // Read documents from specified collection
        db.collection("festivals").getDocuments { snapshot, err in
            if let err = err {
                print("Error \(err)")
            }
            else {
                if let snapshot = snapshot {
                    self.festivals = snapshot.documents.compactMap { doc in
                        return Festival(id: doc.documentID,
                                        centre: doc["centre"] as?
                                                    GeoPoint,
                                        height: doc["height"] as! Double,
                                        width: doc["width"] as! Double,
                                        stages: doc["Stages"] as? [String: GeoPoint],
                                        toilets: doc["Toilets"] as? [GeoPoint],
                                        water: doc["Water"] as? [GeoPoint])
                    }
                }
            }
        }
        
        return festivals.compactMap {festival in festival.id}
    }
    
    func getFestival(name: String) -> Festival {
        // Get reference to database
        let db = Firestore.firestore()
        
        db.collection("festivals").document(name).getDocument { snapshot, err in
            if let err = err {
                print("Error \(err)")
            }
            else {
                if let snapshot = snapshot {
                    // map to a festival struct
                    let docData = snapshot.data()
                    self.festival = Festival(id: snapshot.documentID,
                                        centre: docData?["centre"] as? GeoPoint,
                                        height: docData?["height"] as! Double,
                                        width: docData?["width"] as! Double,
                                        stages: docData?["Stages"] as? [String: GeoPoint],
                                        toilets: docData?["Toilets"] as? [GeoPoint],
                                        water: docData?["Water"] as? [GeoPoint])
                }
            }
        }
        return self.festival
    }
    
}
