//
//  GlassListAPI.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

class GlassListAPI: APIElement {
    typealias Output = BaseResponse<[Glass]>
    
    var path: Path {
        .list
    }
    
    var queryParameters: [(QueryParameterKey, Any)]? {
        [ (.glass, "list") ]
    }
}

struct Glass: Decodable {
    var strGlass: String
}
