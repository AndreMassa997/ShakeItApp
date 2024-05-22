//
//  DetailHeaderViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation

final class DetailHeaderViewModel {
    let alcoholic: String
    let category: String
    let glass: String
    let imageData: Data?
    
    init(alcoholic: String, category: String, glass: String, imageData: Data?) {
        self.alcoholic = alcoholic
        self.category = category
        self.glass = glass
        self.imageData = imageData
    }
}
