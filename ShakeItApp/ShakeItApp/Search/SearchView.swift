//
//  SearchView.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 23/05/24.
//

import SwiftUI

struct SearchView: View {
    let viewModel: SearchViewModel
    @State private var searchText = ""
    @State private var isEditing = false

    var body: some View {
        List {
            ForEach(viewModel.searchedDrinks, id: \.self) { drink in
                DrinkItem(drink: drink)
            }
        }
        .searchable(text: $searchText, prompt: "SEARCH.PLACEHOLDER".localized)
    }
}

struct DrinkItem: View {
    let drink: Drink
    
    var body: some View {
        HStack(spacing: 5) {
            Spacer(minLength: 10)
            
            Image(data: drink.imageData)?
                .resizable()
                .frame(width: 50, height: 50)
                .border(.black, width: 1)
                .clipShape(Circle())
                
            VStack(alignment: .center, spacing: 5) {
                Text(drink.name)
                    .font(.system(size: 16, weight: .light))
                    .tint(.black)
                Text(drink.ingredients.joined(separator: ", "))
                    .font(.system(size: 12, weight: .thin))
                    .tint(.black)
            }
            
            Image(systemName: "chevron.right.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .tint(.black.opacity(0.3))
            
            Spacer(minLength: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(Color(uiColor: UIColor.palette.mainColor))
        .clipShape(Capsule())
    }
}

extension Image {
    init?(data: Data?) {
        guard let data, let image = UIImage(data: data) else { return nil }
        self = .init(uiImage: image)
    }
}
