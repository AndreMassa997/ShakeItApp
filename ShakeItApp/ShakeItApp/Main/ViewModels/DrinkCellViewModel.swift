//
//  DrinkCellViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation

final class DrinkCellViewModel {
    let drink: Drink
    let imageProvider: ImageProvider
    
    init(drink: Drink, imageProvider: ImageProvider) {
        self.drink = drink
        self.imageProvider = imageProvider
    }
    
    let backgroundColor: String = "#fdf9e6"
    
    var ingredientsString: String {
        drink.ingredients.joined(separator: ", ").capitalized
    }
}
