//
//  MainViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation
import Combine

final class MainViewModel {
    private let networkProvider: NetworkProvider
    private var currentPage: Int = 0
    private var allDrinks = [Drink]()
    
    private var alphabetizedPaging: [String] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
        let sortedChars = Array(alphabet).sorted()
        return sortedChars.map { String($0) }
    }
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    //store all available filters that succeeded from API Calls, hide the others
    @Published var availableFilters: [Filter]?
    
    //Data from server for filters
    private var filters: Filters? {
        didSet {
            availableFilters = [
                Filter(filterName: .alcoholic, filterValues: filters?.alcoholicValues),
                Filter(filterName: .category, filterValues: filters?.categoryValues),
                Filter(filterName: .ingredients, filterValues: filters?.ingredientsValues),
                Filter(filterName: .glass, filterValues: filters?.glassValues)
            ].compactMap { $0 }
        }
    }
    
    //MARK: - First Loading
    func firstLoad() {
        Task {
            let (filters, drinkResponse) = await firstLoadingFromServer()
            self.filters = filters
            self.allDrinks.append(contentsOf: parseDrinksResponse(response: drinkResponse))
        }
    }
    
    private func parseDrinksResponse(response: Result<[Drink], ErrorData>) -> [Drink] {
        switch response {
        case let .success(drinks):
            return drinks
        case let .failure(error):
            fatalError("non implemented yet")
        }
    }
    
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
    var filterName: FilterName
    var filterValues: [String]
    
    init?(filterName: FilterName, filterValues: [String]?) {
        guard let filterValues else {
            return nil
        }
        self.filterName = filterName
        self.filterValues = filterValues
    }
}

enum FilterName: String {
    case category = "Category"
    case alcoholic = "Alcoholic"
    case glass = "Glass"
    case ingredients = "Ingredients"
}
