//
//  CategoryListAPI.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

class CategoryListAPI: APIElement {
    typealias Output = BaseResponse<[Category]>
    
    var path: Path {
        .list
    }
    
    var queryParameters: [(QueryParameterKey, Any)]? {
        [ (.category, "list") ]
    }
}

struct Category: Decodable {
    var strCategory: String
}
