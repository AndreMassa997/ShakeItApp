//
//  DrinkCellViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation
import Combine

final class DrinkCellViewModel: ObservableObject {
    let drink: Drink
    let imageProvider: ImageProvider
    
    @Published var drinkImageData: Data?
    var anyCancellables: Set<AnyCancellable> = Set()
    
    let cellTapSubject = PassthroughSubject<Drink, Never>()
    
    init(drink: Drink, imageProvider: ImageProvider) {
        self.drink = drink
        self.imageProvider = imageProvider
        loadImage()
    }
    
    func loadImage() {
        Task {
            let response = await imageProvider.fetchImage(from: drink.imageURL)
            switch response {
            case let .success(data):
                self.drinkImageData = data
            case .failure:
                break
            }
        }
    }
    
    let backgroundColor: String = "#fdf9e6"
    
    var ingredientsString: String {
        drink.ingredients.joined(separator: ", ").capitalized
    }
    
    deinit {
        print("Deinit \(drink.name) view model instance")
        anyCancellables.forEach{ $0.cancel() }
    }
}
