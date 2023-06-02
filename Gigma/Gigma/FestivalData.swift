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
    @Published var festival = Festival(festivalID: "", centre: CodableCoordinate(latitude: 51.5124801, longitude: -0.2182141), height: 0, width: 0, stages: [:], toilets: [], water: [])
    //completion: @escaping ([Festival]) -> Void
    
    func close() {
        
    }
    
    func connect() -> Bool {
        // Get reference to database
        let db = Firestore.firestore()
        
        // Read documents from specified collection
        db.collection("festivals").getDocuments() { snapshot, err in
            if let err = err {
                print("Error \(err)")
            }
            else {
                if let snapshot = snapshot {
                    print(snapshot.documents)
                    self.festivals = snapshot.documents.compactMap { doc in
                        let docData = doc.data()
                        let fest = Festival(festivalID: doc.documentID,
                                        centre: CodableCoordinate.CCfromGeo(geo: (docData["MapCentre"] as! GeoPoint)),
                                        height: docData["MapHeight"] as! Double,
                                        width: docData["MapWidth"] as! Double,
                                        stages: docData["Stages"] as? [String: CodableCoordinate],
                                        toilets: docData["Toilets"] as? [CodableCoordinate],
                                        water: docData["Water"] as? [CodableCoordinate])
                        return fest
                    }
                }
            }
        }
        return true
    }
    
    func getFestivalList() -> [String] {
        print(festivals)
        return self.festivals.compactMap {festival in return festival.festivalID}
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
                                        centre: CodableCoordinate.CCfromGeo(geo: (docData?["MapCentre"] as! GeoPoint)),
                                        height: docData?["MapHeight"] as! Double,
                                        width: docData?["MapWidth"] as! Double,
                                        stages: docData?["Stages"] as? [String: CodableCoordinate],
                                        toilets: docData?["Toilets"] as? [CodableCoordinate],
                                        water: docData?["Water"] as? [CodableCoordinate])
                }
            }
        }
        return self.festival
    }
    
}
