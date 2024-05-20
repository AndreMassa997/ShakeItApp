//
//  Filter.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import Foundation

struct Filter {
    let type: FilterType
    var selectedValues: [String]
    var allValues: [String]
    
    init?(_ type: FilterType, values: [String]?) {
        guard let values else {
            return nil
        }
        self.type = type
        self.selectedValues = values
        self.allValues = values
    }
    
    func isContained(in drink: Drink) -> Bool {
        switch type {
        case .alcoholic:
            return filterBy(values: [drink.alcoholic])
        case .categories:
            return filterBy(values: [drink.category])
        case .glass:
            return filterBy(values: [drink.glass])
        case .ingredients:
            return filterBy(values: drink.ingredients)
        }
    }
    
    func filterBy(values: [String]) -> Bool {
        self.selectedValues.contains(where: values.contains)
    }
    
    mutating func selectOrDeleselectValue(value: String) {
        if let index = selectedValues.firstIndex(where: { $0 == value }) {
            selectedValues.remove(at: index)
        } else {
            selectedValues.append(value)
        }
    }
}

enum FilterType: String {
    case categories
    case alcoholic
    case glass
    case ingredients
    
    var backgroundColor: String {
        "#fdf9e6"
    }
    
    var name: String {
        "MAIN.SECTION.FILTER_\(rawValue.uppercased())".localized
    }
}
