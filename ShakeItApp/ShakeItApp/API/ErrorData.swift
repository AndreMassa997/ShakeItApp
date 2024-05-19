//
//  ErrorData.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation

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
