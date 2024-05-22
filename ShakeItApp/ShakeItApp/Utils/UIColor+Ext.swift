//
//  UIColor+Ext.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import UIKit

extension UIColor {
   static var palette: Palette {
        AppPreferences.shared.palette
    }
}

