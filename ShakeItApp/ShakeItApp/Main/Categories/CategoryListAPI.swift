//
//  CategoryListAPI.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

class CategoryListAPI: APIElement {
    typealias Output = BaseResponse<[Category]>
    
    var path: String {
        "/api/json/v1/1/list.php"
    }
    
    var queryParameters: [(String, Any)]? {
        [ ("c", "list") ]
    }
}

struct Category: Decodable {
    var strCategory: String
}
