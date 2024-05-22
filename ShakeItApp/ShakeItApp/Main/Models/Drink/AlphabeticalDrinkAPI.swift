//
//  DrinkAPI.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

final class AlphabeticalDrinkAPI: APIElement {
    typealias Output = BaseResponse<[Drink]?>
    
    var path: Path {
        .search
    }
    
    var queryParameters: [(QueryParameterKey, Any)]?
}
