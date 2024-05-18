//
//  NetworkManager.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

struct NetworkManager: NetworkProvider {
    func fetchData<T>(with apiElement: T) async -> Result<T.Output, ErrorData> where T : APIElement {
        var urlComponents = URLComponents()
        urlComponents.scheme = apiElement.scheme
        urlComponents.host = apiElement.host
        urlComponents.path = apiElement.path.rawValue
        urlComponents.queryItems = apiElement.queryParameters?.compactMap {
            let value = String(describing: $0.1)
            return URLQueryItem(name: $0.0.rawValue, value: value)
        }
        
        guard let url = urlComponents.url else {
            print("🔴 Invalid URL")
            return .failure(.invalidURL)
        }
        
        print("🔵 URL: \(url.absoluteString)")
        
        guard let dataResponse = try? await URLSession.shared.data(from: url) else {
            print("🔴 Invalid Data Response")
            return .failure(.invalidData)
        }
        
        let data = dataResponse.0
        
        guard let decodedData = try? JSONDecoder().decode(T.Output.self, from: data) else {
            print("🔴 Decoding error")
            return .failure(.decodingError)
        }
        
        return .success(decodedData)
    }
}
