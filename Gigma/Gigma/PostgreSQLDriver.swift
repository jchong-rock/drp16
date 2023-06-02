//
//  PostgreSQLDriver.swift
//  Gigma
//
//  Created by Jake Chong on 02/06/2023.
//

import Foundation
import PostgresClientKit

class PostgreSQLDriver : NSObject, DataBaseDriver {

    private var configuration: ConnectionConfiguration
    private var connection: Connection?
    
    override init() {
        var prefsSQL: NSDictionary?
         if let path = Bundle.main.path(forResource: "PrefsSQL", ofType: "plist") {
            prefsSQL = NSDictionary(contentsOfFile: path)
         }
        
        configuration = PostgresClientKit.ConnectionConfiguration()
        configuration.ssl = prefsSQL!["ssl"] as! Bool
        configuration.host = prefsSQL!["host"] as! String
        configuration.database = prefsSQL!["dbName"] as! String
        configuration.user = prefsSQL!["user"] as! String
        let password = prefsSQL!["password"] as! String
        switch (prefsSQL!["authMethod"] as! String) {
            case "clearText": configuration.credential = Credential.cleartextPassword(password: password)
            case "trust": configuration.credential = Credential.trust
            default: configuration.credential = Credential.scramSHA256(password: password)
        }
    }
    
    func close() {
        connection?.close()
    }
    
    func connect() -> Bool {
        do {
            connection = try PostgresClientKit.Connection(configuration: configuration)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func getFestivalList() -> [String] {
        var festivals: [String] = []
        do {
            let text = "SELECT festival FROM festivals;"
            let statement = try connection!.prepareStatement(text: text)
            defer { statement.close() }
            
            let cursor = try statement.execute()
            defer { cursor.close() }
            
            for row in cursor {
                let columns = try row.get().columns
                let festival = try columns[0].string()
                festivals.append(festival)
            }
        } catch {
            print(error)
        }
        return festivals
    }
    
    func getFestival(name: String) -> Festival {
        
        do {
            let text0 = "SELECT festival, centre_lat, centre_long, height, width FROM festivals WHERE festival = $1;"
            let statement0 = try connection!.prepareStatement(text: text0)
            defer { statement0.close() }

            let cursor0 = try statement0.execute(parameterValues: [ name ])
            defer { cursor0.close() }

            var centre: CodableCoordinate? = nil
            var height: Double = 0
            var width: Double = 0
            
            for row in cursor0 {
                let columns = try row.get().columns
                let centre_lat = try columns[1].double()
                let centre_long = try columns[2].double()
                centre = CodableCoordinate(latitude: centre_lat, longitude: centre_long)
                height = try columns[3].double()
                width = try columns[4].double()
            }
            
            let text1 = "SELECT festival, stage, lat, long FROM stages WHERE festival = $1;"
            let statement1 = try connection!.prepareStatement(text: text1)
            defer { statement1.close() }

            let cursor1 = try statement1.execute(parameterValues: [ name ])
            defer { cursor1.close() }
            
            var stages: [String : CodableCoordinate] = [:]
            
            for row in cursor1 {
                let columns = try row.get().columns
                let stage = try columns[1].string()
                let lat = try columns[2].double()
                let long = try columns[3].double()
                stages[stage] = CodableCoordinate(latitude: lat, longitude: long)
            }
            
            let text2 = "SELECT festival, lat, long FROM toilets WHERE festival = $1;"
            let statement2 = try connection!.prepareStatement(text: text2)
            defer { statement2.close() }

            let cursor2 = try statement1.execute(parameterValues: [ name ])
            defer { cursor2.close() }
            
            var toilets: [CodableCoordinate] = []
            
            for row in cursor2 {
                let columns = try row.get().columns
                let lat = try columns[1].double()
                let long = try columns[2].double()
                toilets.append(CodableCoordinate(latitude: lat, longitude: long))
            }
            
            let text3 = "SELECT festival, lat, long FROM waters WHERE festival = $1;"
            let statement3 = try connection!.prepareStatement(text: text3)
            defer { statement3.close() }

            let cursor3 = try statement1.execute(parameterValues: [ name ])
            defer { cursor3.close() }
            
            var waters: [CodableCoordinate] = []
            
            for row in cursor3 {
                let columns = try row.get().columns
                let lat = try columns[1].double()
                let long = try columns[2].double()
                waters.append(CodableCoordinate(latitude: lat, longitude: long))
            }
            
            let festival = Festival(festivalID: name, centre: centre!, height: height, width: width, stages: stages, toilets: toilets, water: waters)
            return festival
            
        } catch {
            print(error) // better error handling goes here
        }
        return Festival(festivalID: nil, height: 0, width: 0, stages: nil, toilets: nil, water: nil)
    }
    
    
    
}