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
        return IngredientViewModel(ingredient: getIngredientName(for: index), measure: getMeasureName(for: index))
    }
    
    func getIngredientName(for index: Int) -> String {
        drink.ingredients[index]
    }
    
    func getMeasureName(for index: Int) -> String {
        if drink.measures.count == drink.ingredients.count {
            return drink.measures[index]
        }
        return "-"
    }
}
