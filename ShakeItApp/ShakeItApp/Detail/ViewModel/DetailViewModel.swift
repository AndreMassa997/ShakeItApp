//
//  DetailViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 21/05/24.
//

import Foundation

final class DetailViewModel {
    let drink: Drink
    
    init(drink: Drink) {
        self.drink = drink
    }
    
    var instructionText: String? {
        drink.instructions["APP.LANGUAGE".localized]
    }
}

//MARK: ViewModel provider
extension DetailViewModel {
    var headerViewModel: DetailHeaderViewModel {
        DetailHeaderViewModel(alcoholic: drink.alcoholic, category: drink.category, glass: drink.glass, imageData: drink.imageData)
    }
    
    var ingredientsViewModel: IngredientsViewModel {
        IngredientsViewModel(ingredients: drink.ingredients, measures: drink.measures)
    }
}

enum DetailViewSection: String, CaseIterable {
    case instructions, ingredients
    
    var headerName: String {
        "DETAIL.\(rawValue.uppercased())".localized
    }
}
