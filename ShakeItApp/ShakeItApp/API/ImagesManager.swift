//
//  ImagesManager.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation

final class ImagesManager: ImageProvider {
    private let cache: NSCache = NSCache<AnyObject, AnyObject>()
    
    func fetchImage(from url: URL) async -> Result<Data, ErrorData> {
        if let imageFromCache = cache.object(forKey: url as AnyObject) as? Data {
            print("🟠 Image Data cached from: \(url.absoluteString)")
            return .success(imageFromCache)
        }
        
        print("🔵 URL request for image: \(url.absoluteString) at timestamp: \(Int(Date().timeIntervalSince1970 * 1000))")

        guard let dataResponse = try? await URLSession.shared.data(from: url) else {
            print("🔴 Invalid Data Response")
            return .failure(.invalidData)
        }
        
        print("🟢 Image Data Retrieved from: \(url.absoluteString) at timestamp: \(Int(Date().timeIntervalSince1970 * 1000))")
        cache.setObject(dataResponse.0 as AnyObject, forKey: url as AnyObject)
        return .success(dataResponse.0)
    }
}
