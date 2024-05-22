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
    
    @UserDefault("palette") private(set) var storedPalette: String?
    private(set) var palette: Palette = LightPalette()
    
    @discardableResult
    func setupUserPalette(newPalette: Palette, storeNewPalette: Bool = false, deleteStoredValue: Bool = false) -> Bool {
        let oldPalette = palette
        palette = newPalette

        if deleteStoredValue {
            storedPalette = nil
        }
        
        if storeNewPalette {
            storedPalette = newPalette.paletteName
        }
        
        return oldPalette.paletteName != palette.paletteName
    }
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    
    init(_ key: String) {
        self.key = key
    }
    
    var wrappedValue: Value? {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}


