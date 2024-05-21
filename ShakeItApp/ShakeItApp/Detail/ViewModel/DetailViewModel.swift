//
//  DetailViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 21/05/24.
//

import Foundation

final class DetailViewModel: ObservableObject {
    let drink: Drink
    
    init(drink: Drink) {
        self.drink = drink
    }
    
    var instructionText: String? {
        drink.instructions["APP.LANGUAGE".localized]
    }
    
}
