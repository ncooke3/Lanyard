//
//  UIColorExtension.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 6/27/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        guard hexString.count == 9 && hexString.hasPrefix("#") else {
            return nil
        }
        
        let colorValueSubstring = String((hexString.suffix(8)))
        let scanner = Scanner.init(string: colorValueSubstring)
        var hexColor: UInt64 = 0
        scanner.scanHexInt64(&hexColor)
        let mask = 0x000000FF
        
        let r, g, b, a: Int
        r = Int(hexColor >> 24) & mask
        g = Int(hexColor >> 16)  & mask
        b = Int(hexColor >> 8)  & mask
        a = Int(hexColor >> 0)  & mask
        
        let red, blue, green, alpha: CGFloat
        red = CGFloat(r) / 255
        green = CGFloat(g) / 255
        blue = CGFloat(b) / 255
        alpha = CGFloat(a) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString() -> String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02x%02x%02x%02x", Int(red * 255), Int(green * 255), Int(blue * 255), Int(alpha * 255))
    }
}
