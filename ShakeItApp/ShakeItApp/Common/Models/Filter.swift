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
        let sortedValues = values.sorted()
        self.selectedValues = sortedValues
        self.allValues = sortedValues
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
