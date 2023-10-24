//
//  DataBaseDriver.swift
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

@objc protocol DataBaseDriver {
    func close()
    func connect() -> Bool
    func getFestivalList() -> [Int]
    func getDisplayNames() -> [Int : String]
    func getFestival(festivalID: Int) -> Festival
    func getInfo(festivalID: Int) -> [String : String]
    func getTiles(festivalID: Int)
}
