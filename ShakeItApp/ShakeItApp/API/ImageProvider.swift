//
//  ImageProvider.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation

protocol ImageProvider {
    func fetchImage(from url: URL, completion: @escaping (Result<Data, ErrorData>) -> Void)
}
