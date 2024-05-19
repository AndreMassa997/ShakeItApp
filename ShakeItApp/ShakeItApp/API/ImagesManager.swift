//
//  ImagesManager.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation

final class ImagesManager: ImageProvider {
    func fetchImage(from url: URL) async -> Result<Data, ErrorData> {        
        print("🔵 URL request for image: \(url.absoluteString) at timestamp: \(Date().timeIntervalSince1970 * 1000)")
        
        guard let dataResponse = try? await URLSession.shared.data(from: url) else {
            print("🔴 Invalid Data Response")
            return .failure(.invalidData)
        }
        
        print("🟢 Image Data Retrieved from: \(url.absoluteString)")
        return .success(dataResponse.0)
    }
}
