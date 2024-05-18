//
//  APIElement.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

/// This protocol is mandatory for all API Calls and contains all the data necessary

protocol APIElement {
    associatedtype Output: Decodable
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryParameters: [(String, Any)]? { get }
}

extension APIElement{
    var scheme: String{
        "https"
    }
    var host: String {
        "www.thecocktaildb.com"
    }
}
