//
//  IngredientsViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation

final class IngredientsViewModel: BaseViewModel {
    let ingredients: [String]
    let measures: [String]
    
    init(ingredients: [String], measures: [String]) {
        self.ingredients = ingredients
        self.measures = measures
    }
    
    func getIngredientViewModel(for index: Int) -> IngredientViewModel {
        IngredientViewModel(ingredient: getIngredientName(for: index), measure: getMeasureName(for: index))
    }
    
    func getIngredientName(for index: Int) -> String {
        ingredients[index]
    }
    
    func getMeasureName(for index: Int) -> String {
        if measures.count == ingredients.count {
            return measures[index]
        }
        return "-"
    }
}
