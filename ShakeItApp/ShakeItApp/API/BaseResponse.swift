//
//  BaseResponse.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

///This is the base response payload from all of the "CockailDB" APIs

struct BaseResponse<Payload: Decodable>: Decodable {
    let drinks: Payload
}
