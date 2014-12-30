//
//  Colors.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 12/30/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import SpriteKit

class Colors{
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func color (colorString: String) -> UIColor{
        switch colorString{
            case "yellow":
                let colorHex: UInt = 0xCAB033
                return UIColorFromRGB(colorHex)
            case "yellowBright":
                let colorHex: UInt = 0xFFF1AE
                return UIColorFromRGB(colorHex)
            case "orange":
                let colorHex: UInt = 0xCA7733
                return UIColorFromRGB(colorHex)
            case "orangeBright":
                let colorHex: UInt = 0xFF9D4B
                return UIColorFromRGB(colorHex)
            case "blue":
                let colorHex: UInt = 0x304374
                return UIColorFromRGB(colorHex)
            case "blueDark":
                let colorHex: UInt = 0x19367A
                return UIColorFromRGB(colorHex)
            case "brown":
                let colorHex: UInt = 0xD49A6A
                return UIColorFromRGB(colorHex)
            default:
                println("Error: using default case for color- returning white")
                let colorHex: UInt = 0xFFFFFF
                return UIColorFromRGB(colorHex)
        }
    }
    
}