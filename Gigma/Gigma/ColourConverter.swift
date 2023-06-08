//
//  ColourConverter.swift
//  Gigma
//
//  Created by bp821 on 08/06/2023.
//

import Foundation

@objc class ColourConverter : NSObject {
    
    @objc static func toHex(colour: UIColor) -> Int32  {
        let red: CGFloat = CGFloat()
        let green = CGFloat()
        let blue = CGFloat()
        let alpha = CGFloat()
        
        let redPtr = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        
//        let greenPtr = UnsafeMutablePointer(green)
//        let bluePtr = UnsafeMutablePointer(blue)
//        let alphaPtr = UnsafeMutablePointer(alpha)
//        
//        
//        
//        colour.getRed(red: redPtr, green: greenPtr, blue: bluePtr, alpha: alphaPtr)
        
        return 0;
    }
}
