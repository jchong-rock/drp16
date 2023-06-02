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

@objc class FestivalData : NSObject, ObservableObject, DataBaseDriver {
    
    @Published var festivals = [Festival]()
    @Published var festival = Festival(festivalID: "", centre: nil, height: 0, width: 0, stages: [:], toilets: [], water: [])
    
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
                        return Festival(festivalID: doc.documentID,
                                        centre: doc["centre"] as?
                                                    CodableCoordinate,
                                        height: doc["height"] as! Double,
                                        width: doc["width"] as! Double,
                                        stages: doc["Stages"] as? [String: CodableCoordinate],
                                        toilets: doc["Toilets"] as? [CodableCoordinate],
                                        water: doc["Water"] as? [CodableCoordinate])
                    }
                }
            }
        }
        
        return festivals.compactMap {festival in festival.festivalID}
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
                    self.festival = Festival(festivalID: snapshot.documentID,
                                        centre: docData?["centre"] as? CodableCoordinate,
                                        height: docData?["height"] as! Double,
                                        width: docData?["width"] as! Double,
                                        stages: docData?["Stages"] as? [String: CodableCoordinate],
                                        toilets: docData?["Toilets"] as? [CodableCoordinate],
                                        water: docData?["Water"] as? [CodableCoordinate])
                }
            }
        }
        return self.festival
    }
    
}
