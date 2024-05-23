//
//  FiltersViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import Foundation
import Combine

final class FiltersViewModel: BaseViewModel {
    private(set) var filters: [Filter] {
        didSet {
            enableDisableFiltering()
        }
    }
    
    let filtersSubject = PassthroughSubject<[Filter], Never>()
    let filteringEnabled = PassthroughSubject<Bool, Never>()
    let buttonHeaderTapped = PassthroughSubject<Int, Never>()
    
    init(filters: [Filter]) {
        self.filters = filters
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
    
    private func enableDisableFiltering() {
        //Check if the filters contain at least one filter not complete
        let isFilterNotComplete = self.filters.contains(where: { $0.selectedValues.isEmpty })
        
        filteringEnabled.send(!isFilterNotComplete)
    }
    
    private func selectDeselectAllValues(at index: Int) {
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
    
    func getFilterHeaderViewModel(for index: Int) -> LabelButtonHeaderViewModel {
        let data = getHeaderButtonData(at: index)
        let title = filters[index].type.name
        let viewModel = LabelButtonHeaderViewModel(titleText: title, buttonText: data.buttonText, imageName: data.imageName)
        
        viewModel.buttonTappedSubject
            .eraseToAnyPublisher()
            .sink { [weak self] in
                self?.selectDeselectAllValues(at: index)
                self?.buttonHeaderTapped.send(index)
            }
            .store(in: &anyCancellables)
        
        return viewModel
    }
    
    func getHeaderButtonData(at index: Int) -> (buttonText: String, imageName: String) {
        let filter = filters[index]
        let counter = "FILTERS.COUNTER".localized(with: String(filter.selectedValues.count), String(filter.allValues.count))
        let buttonText: String
        let imageName: String
        if filter.selectedValues.count == filter.allValues.count {
            buttonText = counter + " - " + "FILTERS.DESELECT_ALL".localized
            imageName = "checkmark.circle.fill"
        } else {
            buttonText = counter + " - " + "FILTERS.SELECT_ALL".localized
            imageName = "circle"
        }
        return (buttonText, imageName)
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
