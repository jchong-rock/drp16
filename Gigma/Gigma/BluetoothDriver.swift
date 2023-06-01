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
        return [NSUUID(uuidString: "1")! : "dev1", NSUUID(uuidString: "2")! : "dev2", NSUUID(uuidString: "3")! : "dev3"]
    }
}
