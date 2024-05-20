//
//  FiltersViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import Foundation

final class FiltersViewModel {
    @Published var filters: [Filter]
    
    init(filters: [Filter]) {
        self.filters = filters
    }
}
