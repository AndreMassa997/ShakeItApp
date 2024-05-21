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
    
    func getIngredientViewModel(for index: Int) -> IngredientViewModel {
        let ingredient = drink.ingredients[index]
        var measure: String = "-"
        if drink.measures.count == drink.ingredients.count {
            measure = drink.measures[index]
        }
        return IngredientViewModel(ingredient: ingredient, measure: measure)
    }
}
