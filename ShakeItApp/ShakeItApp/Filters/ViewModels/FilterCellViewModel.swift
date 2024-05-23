//
//  FilterCellViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import Foundation

final class FilterCellViewModel: BaseViewModel {
    let filterName: String
    let isSelected: Bool
    
    init(filterName: String, isSelected: Bool) {
        self.filterName = filterName
        self.isSelected = isSelected
    }
}
