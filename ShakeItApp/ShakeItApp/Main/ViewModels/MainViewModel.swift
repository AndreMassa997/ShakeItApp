//
//  MainViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation
import Combine

final class MainViewModel: FullViewModel {
    //store all available filters that succeeded from API Calls, hide the others
    private var selectedFilters: [Filter] = []
    private var currentPage: Int = 0
    private var hasFinishedLoading: Bool {
        currentPage == alphabetizedPaging.count
    }
    private var alphabetizedPaging: [String] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
        return alphabet.map { String($0) }
    }
    
    //Data from server for drinks
    private var allDrinks = [Drink]() {
        didSet {
            //This method will be triggered if new data come from API or if an image is setted in an element of allDrinks
            self.filteredDrinks = filterDrinksByCurrentFilters()
        }
    }
    
    //Store a copy of drinks to use as a data source for the view and to setup when all drinks value change or when a data into a single drink (like an imageData) is stored into an element into allDrinks array
    private(set) var filteredDrinks = [Drink]()
    
    //Published values for reloading
    let filtersErrorSubject = PassthroughSubject<String, Never>()
    let loadingErrorSubject = PassthroughSubject<String, Never>()
    let tapOnDrink = PassthroughSubject<Drink, Never>()
    let buttonHeaderSubject = PassthroughSubject<Int, Never>()
    @Published var tableViewSections: [MainViewSection] = [.loader]
    
    //Data from server for filters
    private var filtersData: FilterResponses? {
        didSet {
            selectedFilters = [
                Filter(.alcoholic, values: filtersData?.alcoholicValues),
                Filter(.categories, values: filtersData?.categoryValues),
                Filter(.ingredients, values: filtersData?.ingredientsValues),
                Filter(.glass, values: filtersData?.glassValues)
            ].compactMap { $0 }
            
            if selectedFilters.count < 4 {
                filtersErrorSubject.send("MAIN.FILTERS.ERROR".localized)
                filtersErrorSubject.send(completion: .finished)
            }
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
    
    func askForNewDrinksIfNeeded(at index: Int) {
        if !hasFinishedLoading && index >= filteredDrinks.count - 1 {
            loadMoreDrinks()
        }
    }
    
    private func loadMoreDrinks() {
        Task {
            let drinkResponse = await loadDataSourceFromServer()
            validateDrinkResponse(response: drinkResponse)
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
            setupTableViewSections()
            loadMoreIfFilteredDrinksIsEmpty()
        case let .failure(error):
            self.loadingErrorSubject.send(error.description)
        }
    }
    
    private func filterDrinksByCurrentFilters() -> [Drink] {
        allDrinks.filter { drink in
            return selectedFilters.allSatisfy{ $0.isContained(in: drink) }
        }
    }
    
    private func storeImageToDrink(with id: String, data: Data?) {
        guard let index = allDrinks.firstIndex(where: { $0.id == id }), allDrinks[index].imageData == nil else { return }
        allDrinks[index].imageData = data
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

//MARK: - ViewModels Provider
extension MainViewModel {
    var filterCarouselViewModel: FiltersCarouselViewModel {
        FiltersCarouselViewModel(filters: self.selectedFilters)
    }
    
    var filtersViewModel: FiltersViewModel {
        let filtersViewModel = FiltersViewModel(filters: self.selectedFilters)
        filtersViewModel.filtersSubject
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.global())
            .sink { [weak self] newFilters in
                guard let self else { return }
                self.setupNewFiltersAndAskNewDataIfNeeded(newFilters)
            }
            .store(in: &anyCancellables)
        return filtersViewModel
    }

    func getDrinkViewModel(for index: Int) -> DrinkCellViewModel {
        let drink = filteredDrinks[index]
        let drinkCellViewModel = DrinkCellViewModel(drink: drink, imageProvider: imageProvider)
        drinkCellViewModel.cellTapSubject
            .eraseToAnyPublisher()
            .sink { [weak self] drinkTapped in
                //Go to details
                self?.tapOnDrink.send(drinkTapped)
            }
            .store(in: &anyCancellables)
        

        drinkCellViewModel.$drinkImageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageData in
                self?.storeImageToDrink(with: drink.id, data: imageData)
            }
            .store(in: &anyCancellables)
        
        return drinkCellViewModel
    }
    
    func getDetailViewModel(for drink: Drink) -> DetailViewModel {
        DetailViewModel(drink: drink)
    }
    
    func getHeaderViewModel(at index: Int) -> LabelButtonHeaderViewModel? {
        let viewModel: LabelButtonHeaderViewModel?
        switch tableViewSections[index] {
        case .drinks:
            viewModel = LabelButtonHeaderViewModel(titleText: "MAIN.SECTION.DRINKS".localized, buttonText: "MAIN.SECTION.GO_TOP".localized, imageName: "chevron.up.circle")
        case .filters:
            viewModel = LabelButtonHeaderViewModel(titleText: "MAIN.SECTION.FILTERS".localized, buttonText: "MAIN.SECTION.FILTER_BY".localized, imageName: "line.3.horizontal.decrease.circle")
        default:
            viewModel = nil
        }
        
        viewModel?.buttonTappedSubject
            .eraseToAnyPublisher()
            .sink { [weak self] in
                self?.buttonHeaderSubject.send(index)
            }
            .store(in: &anyCancellables)
        
        return viewModel
    }
    
    var searchViewModel: SearchViewModel {
        let sv = SearchViewModel(networkProvider: networkProvider, imageProvider: imageProvider)
        sv.searchedDrinks = filteredDrinks
        return sv
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
        //Lowercased filter to avoid unexpected behavior from Filters API and Drinks API
        self.selectedValues.map({ $0.lowercased() }).contains(where: values.map({ $0.lowercased() }).contains)
    }
}
