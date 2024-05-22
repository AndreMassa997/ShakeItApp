//
//  Drink.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation

struct Drink: Decodable, Identifiable {
    let id: String
    let name: String
    let category: String
    let alcoholic: String
    let glass: String
    let ingredients: [String]
    let imageURL: URL
    let instructions: [String: String]
    let measures: [String]
    
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case idDrink
        case strDrink
        case strCategory
        case strAlcoholic
        case strGlass
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strDrinkThumb
        case strInstructions
        case strInstructionsIT
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .idDrink)
        self.name = try container.decode(String.self, forKey: .strDrink)
        self.category = try container.decode(String.self, forKey: .strCategory)
        self.alcoholic = try container.decode(String.self, forKey: .strAlcoholic)
        self.glass = try container.decode(String.self, forKey: .strGlass)
        self.ingredients = [try container.decodeIfPresent(String.self, forKey: .strIngredient1),
                            try container.decodeIfPresent(String.self, forKey: .strIngredient2),
                            try container.decodeIfPresent(String.self, forKey: .strIngredient3),
                            try container.decodeIfPresent(String.self, forKey: .strIngredient4),
                            try container.decodeIfPresent(String.self, forKey: .strIngredient5)].compactMap { $0 }
        
        self.measures = [try container.decodeIfPresent(String.self, forKey: .strMeasure1),
                         try container.decodeIfPresent(String.self, forKey: .strMeasure2),
                         try container.decodeIfPresent(String.self, forKey: .strMeasure3),
                         try container.decodeIfPresent(String.self, forKey: .strMeasure4),
                         try container.decodeIfPresent(String.self, forKey: .strMeasure5)].compactMap { $0 }
        self.imageURL = try container.decode(URL.self, forKey: .strDrinkThumb)
        let instructionsEN = try container.decode(String.self, forKey: .strInstructions)
        let instructionsIT = try container.decodeIfPresent(String.self, forKey: .strInstructionsIT)
        self.instructions = [ "en" : instructionsEN,
                              "it" : instructionsIT ?? instructionsEN]
    }
}

