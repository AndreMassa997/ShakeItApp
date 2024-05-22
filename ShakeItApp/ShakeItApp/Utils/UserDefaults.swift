//
//  UserDefaults.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation

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
