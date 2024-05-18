//
//  AlcoholicListAPI.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

class AlcoholicListAPI: APIElement {
    typealias Output = BaseResponse<[Category]>
    
    var path: Path {
        .list
    }
    
    var queryParameters: [(QueryParameterKey, Any)]? {
        [ (.alcoholic, "list") ]
    }
}

struct Alcoholic: Decodable {
    var strAlcoholic: String
}
