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
    private let imageProvider: ImageProvider
    
    private var alphabetizedPaging: [String] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
        return alphabet.map { String($0) }
    }
    
    init(networkProvider: NetworkProvider, imageProvider: ImageProvider) {
        self.networkProvider = networkProvider
        self.imageProvider = imageProvider
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
                Filter(.categories, values: filters?.categoryValues),
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
    @Published var dataSourceLoadingError: String?
    
    var anyCancellables: Set<AnyCancellable> = Set()
    
    //MARK: - First Loading
    func firstLoad() {
        Task {
            let (filters, drinkResponse) = await firstLoadingFromServer()
            self.filters = filters
            validateDrinkResponse(response: drinkResponse)
        }
    }
    
    func loadDrinks(by name: String? = nil) {
        Task {
            let drinkResponse = await loadDataSourceFromServer(by: name)
            validateDrinkResponse(response: drinkResponse)
        }
    }
    
    func shouldLoadOtherItems(at index: Int) -> Bool {
        index == filteredDrinks.count - 1
    }
}

//MARK: - Utils (Parsing, filtering)
extension MainViewModel {
    private func validateDrinkResponse(response: Result<[Drink], ErrorData>) {
        switch response {
        case let .success(drinks):
            currentPage += 1
            allDrinks.append(contentsOf: drinks)
        case let .failure(error):
            self.dataSourceLoadingError = error.description
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
            let letterToRequest = alphabetizedPaging[currentPage]
            request.queryParameters = [ (.firstLetter, letterToRequest)]
            let response = await networkProvider.fetchData(with: request).map { $0.drinks }
            return response
        }
    }
}

//MARK: ViewModels Provider
extension MainViewModel {
    var filterCarouselViewModel: FiltersCarouselViewModel {
        FiltersCarouselViewModel(filters: self.selectedFilters)
    }
    
    var filtersViewModel: FiltersViewModel {
        FiltersViewModel()
    }

    
    func getDrinkViewModel(for index: Int) -> DrinkCellViewModel{
        let drinkCellViewModel = DrinkCellViewModel(drink: filteredDrinks[index], imageProvider: imageProvider)
        drinkCellViewModel.cellTapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] drinkTapped in
                //Go to details
                print("Tapped \(drinkTapped.name)")
            }
            .store(in: &anyCancellables)
        return drinkCellViewModel
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
        case .categories:
            return filterBy(values: [drink.category])
        case .glass:
            return filterBy(values: [drink.glass])
        case .ingredients:
            return filterBy(values: drink.ingredients)
        }
    }
    
    func filterBy(values: [String]) -> Bool {
        self.selectedValues.contains(where: values.contains)
    }
}

enum FilterType: String {
    case categories
    case alcoholic
    case glass
    case ingredients
    
    var backgroundColor: String {
        "#fdf9e6"
    }
    
    var name: String {
        "MAIN.SECTION.FILTER_\(rawValue.uppercased())".localized
    }
    
//    var color: String {
//        switch self {
//        case .alcoholic:
//            return "#fb8e86"
//        case .category:
//            return "#d9ead3"
//        case .glass:
//            return "#cfe2f3"
//        case .ingredients:
//            return "#fce5cd"
//        }
//    }
}

enum MainViewSection: Int, CaseIterable {
    case filters
    case drinks
    case loader
    
    static subscript(_ index: Int) -> MainViewSection{
        MainViewSection.allCases[index]
    }
    
    var title: String? {
        switch self {
        case .filters:
            return "MAIN.SECTION.FILTERS".localized
        case .drinks:
            return "MAIN.SECTION.DRINKS".localized
        default:
            return nil
        }
    }
    
    var buttonTitle: String? {
        switch self {
        case .filters:
            return "MAIN.SECTION.FILTER_BY".localized
        case .drinks:
            return "MAIN.SECTION.GO_TOP".localized
        default:
            return nil
        }
    }
    
    var buttonImageNamed: String? {
        switch self {
        case .filters:
            return "line.3.horizontal.decrease.circle"
        case .drinks:
            return "chevron.up.circle"
        default:
            return nil
        }
    }
}
