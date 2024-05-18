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
    var path: Path { get }
    var queryParameters: [(QueryParameterKey, Any)]? { get }
}

extension APIElement{
    var scheme: String{
        "https"
    }
    var host: String {
        "www.thecocktaildb.com"
    }
}

enum Path: String {
    case list = "/api/json/v1/1/list.php"
}

enum QueryParameterKey: String {
    case category = "c"
    case alcoholic = "a"
    case glass = "g"
    case ingredients = "i"
}

enum ErrorData: Error {
    case invalidURL
    case invalidData
    case decodingError
    
    var description: String{
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidData:
            return "Invalid Data Received"
        case .decodingError:
            return "Decoding Error from Data"
        }
    }
}
