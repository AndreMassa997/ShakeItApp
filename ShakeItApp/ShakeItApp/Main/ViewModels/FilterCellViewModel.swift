//
//  FilterCellViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

final class FilterCellViewModel {
    private let filter: Filter
    
    init(filter: Filter) {
        self.filter = filter
    }
    
    var filterName: String {
        filter.type.rawValue
    }
    
    var selectedValuesCount: Int {
        filter.selectedValues.count
    }
    
    var allValuesCount: Int {
        filter.allValues.count
    }
    
    var backgroundColor: String {
        filter.type.color
    }
}
