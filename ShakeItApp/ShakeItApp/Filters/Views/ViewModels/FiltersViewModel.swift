//
//  FiltersViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import Foundation
import Combine

final class FiltersViewModel {
    private(set) var filters: [Filter]
    
    private let filtersSubject = PassthroughSubject<[Filter], Never>()
    var filtersPublisher: AnyPublisher<[Filter], Never> {
        filtersSubject.eraseToAnyPublisher()
    }
    
    init(filters: [Filter]) {
        self.filters = filters
    }
    
    func getFilterHeaderValue(for index: Int) -> (text: String, imageName: String) {
        let filter = filters[index]
        let counter = "FILTERS.COUNTER".localized(with: String(filter.selectedValues.count), String(filter.allValues.count))
        if filter.selectedValues.count == filter.allValues.count {
            return (counter + " - " + "FILTERS.DESELECT_ALL".localized, "checkmark.circle.fill")
        } else {
            return (counter + " - " + "FILTERS.SELECT_ALL".localized, "circle")
        }
    }
    
    func selectedFilter(at indexPath: IndexPath) {
        var filter = filters[indexPath.section]
        let value = filter.allValues[indexPath.row]
        filter.selectOrDeleselectValue(value: value)
        filters[indexPath.section] = filter
    }
    
    func applyTapped() {
        filtersSubject.send(filters)
    }
    
    func selectDeselectAllValues(at index: Int) {
        var filter = filters[index]
        filter.selectOrDeselectAll()
        filters[index] = filter
    }
    
    deinit {
        print("Deinit filters view controller")
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

fileprivate extension Filter {
    mutating func selectOrDeleselectValue(value: String) {
        if let index = selectedValues.firstIndex(where: { $0 == value }) {
            selectedValues.remove(at: index)
        } else {
            selectedValues.append(value)
        }
    }
    
    mutating func selectOrDeselectAll() {
        if selectedValues.count < allValues.count {
            selectedValues = allValues
        } else {
            selectedValues.removeAll()
        }
    }
}
