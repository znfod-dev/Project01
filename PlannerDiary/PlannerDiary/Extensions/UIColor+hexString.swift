//
//  UIColor+ hexString.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 17..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    // 0~255값 컬러 세팅
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        let newRed = CGFloat(red) / 255
        let newGreen = CGFloat(green) / 255
        let newBlue = CGFloat(blue) / 255
        
        self.init(red:newRed, green:newGreen, blue:newBlue, alpha:alpha)
    }
    
    // 16진수로 컬러값 세팅
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let newRed = CGFloat((hex >> 16) & 0xff) / 255
        let newGreen = CGFloat((hex >> 08) & 0xff) / 255
        let newBlue = CGFloat((hex >> 00) & 0xff) / 255

        self.init(red:newRed, green:newGreen, blue:newBlue, alpha:alpha)
    }
    
    // 16진수문자로 컬러값 세팅
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)
        return String(format: "#%06x", rgb)
    }
}
