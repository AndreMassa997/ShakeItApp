//
//  UIColor+Ext.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import UIKit

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted.removeFirst()
        }
        
        let scanner = Scanner(string: hexFormatted)
        var rgbValue: UInt64 = 0
        guard scanner.scanHexInt64(&rgbValue) else { return nil }
        
        let red = CGFloat((rgbValue >> 16) & 0xFF) / 255
        let green = CGFloat((rgbValue >> 8) & 0xFF) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static var palette: Palette {
        AppPreferences.shared.palette
    }
}

