//
//  FiltersCarouselViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation

final class FiltersCarouselViewModel {
    private let filters: [Filter]
    
    init(filters: [Filter]) {
        self.filters = filters
    }
    
    var numberOfItems: Int {
        self.filters.count
    }
    
    func getFilterCellViewModel(at indexPath: IndexPath) -> FilterCellViewModel {
        FilterCellViewModel(filter: filters[indexPath.row])
    }
    
}
