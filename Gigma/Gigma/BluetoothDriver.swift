//
//  BluetoothDriver.swift
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

import Foundation

@objc protocol BluetoothDriver {
    func nearbyBluetoothDevices() -> [NSUUID: NSString]
}

@objc class Bluetoother : NSObject, BluetoothDriver {
    func nearbyBluetoothDevices() -> [NSUUID: NSString] {
        return [NSUUID(uuidString: "68753A44-4D6F-1226-9C60-0050E4C00067")! : "dev1", NSUUID(uuidString: "68753A44-4D6F-1226-9C60-0050E4C00068")! : "dev2", NSUUID(uuidString: "68753A44-4D6F-1226-9C60-0050E4C00069")! : "dev3"]
    }
}
