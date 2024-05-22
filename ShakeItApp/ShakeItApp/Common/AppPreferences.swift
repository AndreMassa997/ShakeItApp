//
//  AppPreferences.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation

final class AppPreferences {
    private init() {}
    
    static let shared = AppPreferences()
    
    var palette: Palette = LightPalette()
    
}
