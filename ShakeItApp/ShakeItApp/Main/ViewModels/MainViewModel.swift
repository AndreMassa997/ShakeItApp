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
    private let imageProvider: ImageProvider
    var anyCancellables: Set<AnyCancellable> = Set()

    init(networkProvider: NetworkProvider, imageProvider: ImageProvider) {
        self.networkProvider = networkProvider
        self.imageProvider = imageProvider
    }
    //store all available filters that succeeded from API Calls, hide the others
    private var selectedFilters: [Filter] = []
    //Data from server for drinks
    private var allDrinks = [Drink]()
    private(set) var filteredDrinks = [Drink]()
    
    //Published values for reloading
    @Published var dataSourceLoadingError: String?
    @Published var tableViewSections: [MainViewSection] = [.loader]
    
    private var alphabetizedPaging: [String] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
        return alphabet.map { String($0) }
    }
    
    private var currentPage: Int = 0 {
        didSet {
            if hasFinishedLoading {
                self.setupTableViewSections()
            }
        }
    }
    
    private var hasFinishedLoading: Bool {
        currentPage == alphabetizedPaging.count
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
    
    //MARK: - First Loading
    func firstLoad() {
        Task {
            let (filters, drinkResponse) = await firstLoadingFromServer()
            self.filtersData = filters
            validateDrinkResponse(response: drinkResponse)
        }
    }
    
    func loadMoreDrinks() {
        Task {
            let drinkResponse = await loadDataSourceFromServer()
            validateDrinkResponse(response: drinkResponse)
        }
    }
    
    func askForNewDrinksIfNeeded(at index: Int) {
        if !hasFinishedLoading && index >= filteredDrinks.count - 1 {
            loadMoreDrinks()
        }
    }
    
    private func setupNewFiltersAndAskNewDataIfNeeded(_ filters: [Filter]) {
        self.selectedFilters = filters
        self.filteredDrinks = self.filterDrinksByCurrentFilters()
        self.setupTableViewSections()
        loadMoreIfFilteredDrinksIsEmpty()
    }
    
    /// Method to setup the table view section and trigger update of the table view
    private func setupTableViewSections() {
        var sections: [MainViewSection] = []
        if !selectedFilters.isEmpty {
            sections.append(.filters)
        }
        if !filteredDrinks.isEmpty {
            sections.append(.drinks)
        }
        if hasFinishedLoading {
            if filteredDrinks.isEmpty {
                sections.append(.noItems)
            }
        } else {
            sections.append(.loader)
        }
        self.tableViewSections = sections
    }
    
    private func loadMoreIfFilteredDrinksIsEmpty() {
        if filteredDrinks.isEmpty, !hasFinishedLoading {
            loadMoreDrinks()
        }
    }
    
    func reloadDrinkFromError() {
        loadMoreDrinks()
    }
}

//MARK: - Utils (Parsing, filtering)
extension MainViewModel {
    private func validateDrinkResponse(response: Result<[Drink], ErrorData>) {
        switch response {
        case let .success(drinks):
            currentPage += 1
            allDrinks.append(contentsOf: drinks)
            filteredDrinks = self.filterDrinksByCurrentFilters()
            setupTableViewSections()
            loadMoreIfFilteredDrinksIsEmpty()
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
    
    private func loadDataSourceFromServer() async -> Result<[Drink], ErrorData> {
        let request = AlphabeticalDrinkAPI()
        let letterToRequest = alphabetizedPaging[currentPage]
        request.queryParameters = [ (.firstLetter, letterToRequest)]
        let response = await networkProvider.fetchData(with: request).map { $0.drinks ?? [] }
        return response
    }
}

//MARK: ViewModels Provider
extension MainViewModel {
    var filterCarouselViewModel: FiltersCarouselViewModel {
        FiltersCarouselViewModel(filters: self.selectedFilters)
    }
    
    var filtersViewModel: FiltersViewModel {
        let filtersViewModel = FiltersViewModel(filters: self.selectedFilters)
        filtersViewModel.filtersSubject
            .eraseToAnyPublisher()
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
        drinkCellViewModel.cellTapSubject
            .eraseToAnyPublisher()
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

enum MainViewSection: Equatable {
    case filters
    case drinks
    case loader
    case noItems
    
    var headerData: (title: String, buttonTitle: String, buttonImageName: String)? {
        switch self {
        case .filters:
            return ("MAIN.SECTION.FILTERS".localized, "MAIN.SECTION.FILTER_BY".localized, "line.3.horizontal.decrease.circle")
        case .drinks:
            return ("MAIN.SECTION.DRINKS".localized, "MAIN.SECTION.GO_TOP".localized, "chevron.up.circle")
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
