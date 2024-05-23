//
//  FilterCarouselCellViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

final class FilterCarouselCellViewModel: BaseViewModel {
    private let filter: Filter
    
    init(filter: Filter) {
        self.filter = filter
    }
    
    var filterName: String {
        filter.type.name
    }
    
    var selectedValuesCount: Int {
        filter.selectedValues.count
    }
    
    var allValuesCount: Int {
        filter.allValues.count
    }
    
    var imageName: String {
        filter.type.rawValue.lowercased()
    }
}
