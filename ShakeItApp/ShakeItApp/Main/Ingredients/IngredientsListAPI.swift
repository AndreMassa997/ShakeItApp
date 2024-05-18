//
//  IngredientsListAPI.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

class IngredientsListAPI: APIElement {
    typealias Output = BaseResponse<[Ingredient]>
    
    var path: Path {
        .list
    }
    
    var queryParameters: [(QueryParameterKey, Any)]? {
        [ (.ingredients, "list") ]
    }
}

struct Ingredient: Decodable {
    var strIngredient1: String
}
