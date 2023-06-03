//
//  DataBaseDriver.swift
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

@objc protocol DataBaseDriver {
    func close()
    func connect() -> Bool
    func getFestivalList() -> [String]
    func getFestival(name: String) -> Festival
}
