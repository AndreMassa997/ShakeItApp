//
//  FiltersViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import Foundation

final class FiltersViewModel {
    private(set) var filters: [Filter]
    
    init(filters: [Filter]) {
        self.filters = filters
    }
    
    func getFiltersCountLabel(for index: Int) -> String {
        let filter = filters[index]
        return "MAIN.SECTION.FILTER_SELECTION".localized(with: String(filter.selectedValues.count), String(filter.allValues.count))
    }
    
    func selectedFilter(at indexPath: IndexPath) {
        var filter = filters[indexPath.section]
        let value = filter.allValues[indexPath.row]
        filter.selectOrDeleselectValue(value: value)
        filters[indexPath.section] = filter
    }
}

//MARK: - ViewModels provider
extension FiltersViewModel {
    func getFilterCellViewModel(for indexPath: IndexPath) -> FilterCellViewModel {
        let filter = filters[indexPath.section]
        let value = filter.allValues[indexPath.row]
        let isSelected = filter.selectedValues.contains(where: { $0 == value })
        let viewModel = FilterCellViewModel(filterName: value, isSelected: isSelected)
        return viewModel
    }
}
