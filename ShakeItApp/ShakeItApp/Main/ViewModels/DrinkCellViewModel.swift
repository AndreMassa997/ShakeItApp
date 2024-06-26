//
//  DrinkCellViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import Foundation
import Combine

final class DrinkCellViewModel: ImageViewModel {
    private (set) var drink: Drink
    let cellTapSubject = PassthroughSubject<Drink, Never>()
    
    @Published var drinkImageData: Data?
    
    init(drink: Drink, imageProvider: ImageProvider) {
        self.drink = drink
        super.init(imageProvider: imageProvider)
    }
    
    var ingredientsString: String {
        drink.ingredients.joined(separator: ", ").capitalized
    }
    
    func getImageDataAndAskIfNeeded() -> Data? {
        guard let imageData = drink.imageData else {
            fetchImageData()
            return nil
        }
        return imageData
    }
    
    private func fetchImageData() {
        Task(priority: .background, operation: {
            let response = await imageProvider.fetchImage(from: drink.imageURL)
            switch response {
            case let .success(data):
                self.drinkImageData = data
                self.drink.imageData = data
            case .failure:
                break
            }
        })
    }
    
    deinit {
        print("Deinit \(drink.name) view model instance")
        anyCancellables.forEach{ $0.cancel() }
    }
}
