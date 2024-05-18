//
//  NetworkProvider.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

protocol NetworkProvider {
    func fetchData<T: APIElement>(with apiElement: T) async -> Result<T.Output, ErrorData>
}
