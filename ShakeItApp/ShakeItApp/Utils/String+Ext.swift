//
//  String+Ext.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(with attributes: CVarArg...) -> String {
        String(format: self.localized, attributes)
    }
}
