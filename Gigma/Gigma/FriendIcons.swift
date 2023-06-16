//
//  FriendIcons.swift
//  Gigma
//
//  Created by kup21 on 16/06/2023.
//

import Foundation

/* Different types of possibe friend icons */
enum FriendIcon : String, CaseIterable {
    case DEFAULT = "person.circle"
    case OTHER   = "person.fill.turn.right"
    //TODO: Add more options
}

@objc class FriendIcons : NSObject {
    
    @objc static func getDefault() -> String {
        return FriendIcon.DEFAULT.rawValue
    }
    
    static func getIcon(icon: FriendIcon) -> String {
        return icon.rawValue
    }
    
    @objc static func getAllList() -> [String] {
        return FriendIcon.allCases.map(getIcon)
    }
}
