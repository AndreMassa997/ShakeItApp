//
//  DetailViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 21/05/24.
//

import Foundation

final class DetailViewModel: BaseViewModel {
    let drink: Drink
    
    init(drink: Drink) {
        self.drink = drink
        super.init()
    }
}

//MARK: ViewModel provider
extension DetailViewModel {
    var headerViewModel: DetailHeaderViewModel {
        DetailHeaderViewModel(alcoholic: drink.alcoholic, category: drink.category, glass: drink.glass, imageData: drink.imageData)
    }
    
    var ingredientsViewModel: IngredientsViewModel {
        IngredientsViewModel(ingredients: drink.ingredients, measures: drink.measures)
    }
    
    var labelCellViewModel: LabelCellViewModel {
        let instructionText = drink.instructions["APP.LANGUAGE".localized] ?? "-"
        return LabelCellViewModel(text: instructionText)
    }
    
    func getLabelHeaderViewModel(at index: Int) -> LabelHeaderViewModel {
        LabelHeaderViewModel(text: DetailViewSection.allCases[index].headerName)
    }
}

enum DetailViewSection: String, CaseIterable {
    case instructions, ingredients
    
    var headerName: String {
        "DETAIL.\(rawValue.uppercased())".localized
    }
}
