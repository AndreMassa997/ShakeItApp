//
//  ImagesManager.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation

final class ImagesManager: ImageProvider {
    private let cache: NSCache = NSCache<AnyObject, AnyObject>()
    
    func fetchImage(from url: URL, completion: @escaping (Result<Data, ErrorData>) -> Void) {
        if let imageFromCache = cache.object(forKey: url as AnyObject) as? Data {
            print("🟠 Image Data cached from: \(url.absoluteString)")
            return completion(.success(imageFromCache))
        }
        
        print("🔵 URL request for image: \(url.absoluteString) at timestamp: \(Int(Date().timeIntervalSince1970 * 1000))")

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data else {
                print("🔴 Decoding error")
                return completion(.failure(.decodingError))
            }
            print("🟢 Image Data Retrieved from: \(url.absoluteString) at timestamp: \(Int(Date().timeIntervalSince1970 * 1000))")
            
            self?.cache.setObject(data as AnyObject, forKey: url as AnyObject)
            completion(.success(data))
        }
        .resume()
    }
}
