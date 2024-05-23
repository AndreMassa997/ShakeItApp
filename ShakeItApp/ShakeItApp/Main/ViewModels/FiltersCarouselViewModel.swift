//
//  FiltersCarouselViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation

final class FiltersCarouselViewModel: BaseViewModel {
    let filters: [Filter]
    
    init(filters: [Filter]) {
        self.filters = filters
    }
    
    func getFilterCellViewModel(at indexPath: IndexPath) -> FilterCarouselCellViewModel {
        FilterCarouselCellViewModel(filter: filters[indexPath.row])
    }
}
