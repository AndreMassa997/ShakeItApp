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

extension FiltersViewModel {
    func getFilterCellViewModel(for indexPath: IndexPath) -> FilterCellViewModel {
        let filter = filters[indexPath.section]
        let value = filter.allValues[indexPath.row]
        let isSelected = filter.selectedValues.contains(where: { $0 == value })
        let viewModel = FilterCellViewModel(filterName: value, isSelected: isSelected)
        return viewModel
    }
}
