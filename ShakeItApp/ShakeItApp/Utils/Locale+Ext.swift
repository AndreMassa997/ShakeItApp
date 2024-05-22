//
//  Locale+Ext.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation

extension Locale {
    static var currentLanguage: String {
        if #available(iOS 16, *) {
            return Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            return Locale.current.languageCode ?? "en"
        }
    }
}
