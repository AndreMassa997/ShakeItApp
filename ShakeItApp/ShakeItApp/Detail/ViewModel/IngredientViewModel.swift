//
//  IngredientViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 21/05/24.
//

import Foundation

final class IngredientViewModel {
    let ingredient: String
    let measure: String
     
    init(ingredient: String, measure: String) {
        self.ingredient = ingredient
        self.measure = measure
    }
    
    var backgroundColor: String {
        "#fdf9e6"
    }
    
}
