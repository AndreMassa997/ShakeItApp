//
//  MainViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    private let networkProvider: NetworkProvider
    private var currentPage: Int = 0
    
    private var alphabetizedPaging: [String] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
        let sortedChars = Array(alphabet).sorted()
        return sortedChars.map { String($0) }
    }
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    private var allDrinks = [Drink]() {
        didSet {
            filteredDrinks = self.filterDrinksByCurrentFilters()
        }
    }
    
    //Data from server for filters
    private var filters: Filters? {
        didSet {
            availableFilters = [
                Filter(.alcoholic, values: filters?.alcoholicValues),
                Filter(.category, values: filters?.categoryValues),
                Filter(.ingredients, values: filters?.ingredientsValues),
                Filter(.glass, values: filters?.glassValues)
            ].compactMap { $0 }
            selectedFilters = availableFilters ?? []
        }
    }
    
    //store all available filters that succeeded from API Calls, hide the others
    private var availableFilters: [Filter]?
    @Published var selectedFilters: [Filter] = []
    @Published var filteredDrinks = [Drink]()
    
    var anyCancellables: Set<AnyCancellable> = Set()
    
    //MARK: - First Loading
    func firstLoad() {
        Task {
            let (filters, drinkResponse) = await firstLoadingFromServer()
            self.filters = filters
            self.allDrinks.append(contentsOf: parseDrinksResponse(response: drinkResponse))
        }
    }
    
}

//MARK: - Utils (Parsing, filtering)
extension MainViewModel {
    private func parseDrinksResponse(response: Result<[Drink], ErrorData>) -> [Drink] {
        switch response {
        case let .success(drinks):
            return drinks
        case let .failure(error):
            fatalError("non implemented yet")
        }
    }
    
    private func filterDrinksByCurrentFilters() -> [Drink] {
        allDrinks.filter { drink in
            return selectedFilters.allSatisfy{ $0.isContained(in: drink) }
        }
    }
}

//MARK: - API Implementations
extension MainViewModel {
    ///First Loading - filters + first data source in parallel using async let - await
    private func firstLoadingFromServer() async -> (Filters, Result<[Drink], ErrorData>){
        async let filters = loadFiltersValuesFromServer()
        async let alphabeticalRequest = loadDataSourceFromServer()
        
        return await (filters, alphabeticalRequest)
    }
    
    ///Load filters in parallel using async let - await
    private func loadFiltersValuesFromServer() async -> Filters{
        async let categoryList = networkProvider.fetchData(with: CategoryListAPI())
        async let alcoholicList = networkProvider.fetchData(with: AlcoholicListAPI())
        async let ingredientsList = networkProvider.fetchData(with: IngredientsListAPI())
        async let glassList = networkProvider.fetchData(with: GlassListAPI())
        
        return await Filters(categoryList: categoryList, alcoholicList: alcoholicList, ingrendientsList: ingredientsList, glassList: glassList)
    }
    
    private func loadDataSourceFromServer(by name: String? = nil) async -> Result<[Drink], ErrorData> {
        if let name {
            //TODO: Implements filter by naming from server
            fatalError("non implemented yet")
        } else {
            let request = AlphabeticalDrinkAPI()
            let letterToRequest = alphabetizedPaging[currentPage + 1]
            request.queryParameters = [ (.firstLetter, letterToRequest)]
            return await networkProvider.fetchData(with: request).map { $0.drinks }
        }
    }
}

struct Filters {
    var categoryList: Result<CategoryListAPI.Output, ErrorData>
    var alcoholicList: Result<AlcoholicListAPI.Output, ErrorData>
    var ingrendientsList: Result<IngredientsListAPI.Output, ErrorData>
    var glassList: Result<GlassListAPI.Output, ErrorData>
    
    var categoryValues: [String]? {
        if case .success(let value) = categoryList {
            return value.drinks.map(\.strCategory)
        }
        return nil
    }
    
    var alcoholicValues: [String]? {
        if case .success(let value) = alcoholicList {
            return value.drinks.map(\.strAlcoholic)
        }
        return nil
    }
    
    var ingredientsValues: [String]? {
        if case .success(let value) = ingrendientsList {
            return value.drinks.map(\.strIngredient1)
        }
        return nil
    }
    
    var glassValues: [String]? {
        if case .success(let value) = glassList {
            return value.drinks.map(\.strGlass)
        }
        return nil
    }
}

struct Filter {
    let type: FilterType
    var selectedValues: [String]
    var allValues: [String]
    
    init?(_ type: FilterType, values: [String]?) {
        guard let values else {
            return nil
        }
        self.type = type
        self.selectedValues = values
        self.allValues = values
    }
    
    func isContained(in drink: Drink) -> Bool {
        switch type {
        case .alcoholic:
            return filterBy(values: [drink.alcoholic])
        case .category:
            return filterBy(values: [drink.category])
        case .glass:
            return filterBy(values: [drink.glass])
        case .ingredients:
            return filterBy(values: drink.ingredients)
        }
    }
    
    func filterBy(values: [String]) -> Bool {
        self.selectedValues.allSatisfy { element in values.contains(element) }
    }
}

enum FilterType: String {
    case category = "Category"
    case alcoholic = "Alcoholic"
    case glass = "Glass"
    case ingredients = "Ingredients"
    
    var color: String {
        switch self {
        case .alcoholic:
            return "#fb8e86"
        case .category:
            return "#d9ead3"
        case .glass:
            return "#cfe2f3"
        case .ingredients:
            return "#fce5cd"
        }
    }
}
