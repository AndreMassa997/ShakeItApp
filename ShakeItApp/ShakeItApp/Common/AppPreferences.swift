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
    
    //MARK: - Theme - Palette
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
    
    var currentTheme: String {
        switch storedPalette {
            case "light":
                return "MAIN.SETTINGS.THEME.LIGHT".localized
            case "dark":
                return "MAIN.SETTINGS.THEME.DARK".localized
            default:
                return "MAIN.SETTINGS.AUTO".localized
        }
    }
    
    //MARK: - Language
    @UserDefault("language") private(set) var storedLanguage: String?
    func setupLanguage(languageCode: String?) -> Bool {
        let currentLanguage = storedLanguage ?? Locale.currentLanguage
        storedLanguage = languageCode
        return currentLanguage != storedLanguage
    }
    
    var currentLanguage: String {
        switch storedLanguage {
            case "en":
                return "MAIN.SETTINGS.LANGUAGE.ENG".localized
            case "it":
                return "MAIN.SETTINGS.LANGUAGE.ITA".localized
            default:
                return "MAIN.SETTINGS.AUTO".localized
        }
    }
}

