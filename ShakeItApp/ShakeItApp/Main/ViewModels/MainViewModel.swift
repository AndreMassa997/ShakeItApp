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
    
    //Data from server for drinks
    private var allDrinks = [Drink]() {
        didSet {
            filteredDrinks = self.filterDrinksByCurrentFilters()
        }
    }
    
    //Data from server for filters
    private var filtersData: FilterResponses? {
        didSet {
            selectedFilters = [
                Filter(.alcoholic, values: filtersData?.alcoholicValues),
                Filter(.categories, values: filtersData?.categoryValues),
                Filter(.ingredients, values: filtersData?.ingredientsValues),
                Filter(.glass, values: filtersData?.glassValues)
            ].compactMap { $0 }
        }
    }
    
    //store all available filters that succeeded from API Calls, hide the others
    private var selectedFilters: [Filter] = []
    
    //Published values for reloading
    @Published var filteredDrinks = [Drink]()
    @Published var dataSourceLoadingError: String?
    
    var anyCancellables: Set<AnyCancellable> = Set()
    
    var hasFinishedLoading: Bool {
        currentPage == alphabetizedPaging.count
    }
    
    //MARK: - First Loading
    func firstLoad() {
        Task {
            let (filters, drinkResponse) = await firstLoadingFromServer()
            self.filtersData = filters
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
        !hasFinishedLoading && index >= filteredDrinks.count - 1
    }
    
    func setupNewFiltersAndAskNewDataIfNeeded(_ filters: [Filter]) {
        self.selectedFilters = filters
        self.filteredDrinks = self.filterDrinksByCurrentFilters()
        if filteredDrinks.count == 0 {
            loadDrinks()
        }
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
    private func firstLoadingFromServer() async -> (FilterResponses, Result<[Drink], ErrorData>){
        async let filters = loadFiltersValuesFromServer()
        async let alphabeticalRequest = loadDataSourceFromServer()
        
        return await (filters, alphabeticalRequest)
    }
    
    ///Load filters in parallel using async let - await
    private func loadFiltersValuesFromServer() async -> FilterResponses{
        async let categoryList = networkProvider.fetchData(with: CategoryListAPI())
        async let alcoholicList = networkProvider.fetchData(with: AlcoholicListAPI())
        async let ingredientsList = networkProvider.fetchData(with: IngredientsListAPI())
        async let glassList = networkProvider.fetchData(with: GlassListAPI())
        
        return await FilterResponses(categoryList: categoryList, alcoholicList: alcoholicList, ingrendientsList: ingredientsList, glassList: glassList)
    }
    
    private func loadDataSourceFromServer(by name: String? = nil) async -> Result<[Drink], ErrorData> {
        if let name {
            //TODO: Implements filter by naming from server
            fatalError("non implemented yet")
        } else {
            let request = AlphabeticalDrinkAPI()
            let letterToRequest = alphabetizedPaging[currentPage]
            request.queryParameters = [ (.firstLetter, letterToRequest)]
            let response = await networkProvider.fetchData(with: request).map { $0.drinks ?? [] }
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
        let filtersViewModel = FiltersViewModel(filters: self.selectedFilters)
        filtersViewModel.filtersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newFilters in
                guard let self else { return }
                self.setupNewFiltersAndAskNewDataIfNeeded(newFilters)
            }
            .store(in: &anyCancellables)
        return filtersViewModel
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

fileprivate struct FilterResponses {
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

fileprivate extension Filter {
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
    
    private func filterBy(values: [String]) -> Bool {
        self.selectedValues.contains(where: values.contains)
    }
}
