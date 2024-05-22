//
//  String+Ext.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import Foundation

extension String {
    var localized: String {
        let language: String
        if let storedLang = AppPreferences.shared.storedLanguage {
            language = storedLang
        } else {
            language = Locale.currentLanguage
        }
        
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
    func localized(with attributes: CVarArg...) -> String {
        String(format: self.localized, attributes)
    }
}

extension Locale {
    static var currentLanguage: String {
        if #available(iOS 16, *) {
            return Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            return Locale.current.languageCode ?? "en"
        }
    }
}
