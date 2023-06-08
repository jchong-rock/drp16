//
//  BluetoothDriver.swift
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

import Foundation

@objc protocol BluetoothDriver {
    func nearbyBluetoothDevices() -> [NSUUID: NSString]
    func getLocation(uuid: NSUUID) -> CodableCoordinate
    func broadcastName()
    
    func useCentral()
    func usePeripheral()
}

@objc class Bluetoother : NSObject, BluetoothDriver {
    func broadcastName() {
        
    }
    
    func useCentral() {
        
    }
    
    func usePeripheral() {
        
    }
    
    func getLocation(uuid: NSUUID) -> CodableCoordinate {
        if uuid == NSUUID(uuidString: "68753A44-4D6F-1226-9C60-0050E4C00067") {
            return CodableCoordinate(latitude: 51.500111466166636, longitude: -0.1779596309522493)
        }
        if uuid == NSUUID(uuidString: "68753A44-4D6F-1226-9C60-0050E4C00068") {
            return CodableCoordinate(latitude: 51.49935007193074, longitude: -0.17989082138280968)
        }
        return CodableCoordinate(latitude: 51.497887357840995, longitude: -0.178174207666756)
    }
    
    func nearbyBluetoothDevices() -> [NSUUID: NSString] {
        return [NSUUID(uuidString: "68753A44-4D6F-1226-9C60-0050E4C00067")! : "dev1", NSUUID(uuidString: "68753A44-4D6F-1226-9C60-0050E4C00068")! : "dev2", NSUUID(uuidString: "68753A44-4D6F-1226-9C60-0050E4C00069")! : "dev3"]
    }
}
