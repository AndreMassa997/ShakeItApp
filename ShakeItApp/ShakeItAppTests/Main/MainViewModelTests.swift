//
//  MainViewModelTests.swift
//  ShakeItAppTests
//
//  Created by Andrea Massari on 23/05/24.
//

import XCTest
@testable import ShakeItApp
import Combine

final class MainViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }


    //MARK: Sections tests
    func test_firstLoad_shouldPopulateSectionsOnValidData() throws {
        let drinks = makeFakeDrinks()
        let filter = makeFakeAlcoholicFilters()
        let networkProvider = makeNetworkProvider(with: drinks, alcoholicFiter: filter)
        let sut = makeSUT(networkProvider: networkProvider)
        
        //Providing filters data on network manager should populate filter section
        
        sut.firstLoad()

        try awaitPublisher(sut.$tableViewSections, numberOfUpdatesExpected: 2) { update, value in
            switch update {
            case 1:
                //1. Expect to have only loader at lauch time
                XCTAssertEqual(value, [.loader])
            case 2:
                //2. Expect to have both drinks and filter sections after first load succeeded
                XCTAssertEqual(value, [.filters, .drinks, .loader])
            default:
                XCTFail("Expected only two returns")
            }
        }
    }

    func test_firstLoad_shouldPopulateOnlyDrinksSectionsOnFiltersError() throws {
        let drinks = makeFakeDrinks()
        let networkProvider = makeNetworkProvider(with: drinks)
        let sut = makeSUT(networkProvider: networkProvider)
        
        
        //Expect to have only drinks sections after first load filters fails from network manager
        
        sut.firstLoad()
        
        try awaitPublisher(sut.$tableViewSections, numberOfUpdatesExpected: 2) { update, value in
            switch update {
            case 1:
                //1. Expect to have only loader at lauch time
                XCTAssertEqual(value, [.loader])
            case 2:
                //2. Expect to have only drinks sections after first load succeeded
                XCTAssertEqual(value, [.drinks, .loader])
            default:
                XCTFail("Expected only two returns")
            }
        }
    }
    
    func test_firstLoad_shouldShowErrorOnInvalidResponse() throws {
        let errorNetworkProvider = makeNetworkProvider()
        let sut = makeSUT(networkProvider: errorNetworkProvider)
        
        
        //Expect to hide both filters and drinks section after first load fails for all requests
        sut.firstLoad()

        let expectation = XCTestExpectation(description: "Expect to trigger error subject")
        var error: String?
        try awaitPublisher(sut.loadingErrorSubject, numberOfUpdatesExpected: 1) { _, err in
            error = err
            expectation.fulfill()
        }
        
        try awaitPublisher(sut.$tableViewSections, numberOfUpdatesExpected: 1) { update, value in
            switch update {
            case 1:
                //1. Expect to have only loader at lauch time
                XCTAssertEqual(value, [.loader])
            default:
                XCTFail("Expected only two returns")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(error)
    }
    
    func test_loadMoreDrinks_shouldPopulateSectionsOnValidData() throws {
        let drinks = makeFakeDrinks(count: 20)
        let networkProvider = makeNetworkProvider(with: drinks)
        let sut = makeSUT(networkProvider: networkProvider)
        
        //Expect to ask new drinks and return new drink section (without first loading)
        
        sut.askForNewDrinksIfNeeded(at: 0)
        
        try awaitPublisher(sut.$tableViewSections, numberOfUpdatesExpected: 2) { update, value in
            switch update {
            case 1:
                //1. Expect to have only loader at lauch time
                XCTAssertEqual(value, [.loader])
            case 2:
                XCTAssertEqual(value, [.drinks, .loader])
            default:
                XCTFail("Expected only two returns")
            }
        }
    }
    
    func test_loadMoreDrinksUntilFinishing_shouldRemoveLoader() throws {
        let drinks = makeFakeDrinks()
        let networkProvider = makeNetworkProvider(with: drinks)
        let sut = makeSUT(networkProvider: networkProvider)
                
        //Make the maximum amount of requests for new drinks alphabetically (36), should stop aand return only drinks without more loader
        let updatesExpected = 36 + 1
        
        try awaitPublisher(sut.$tableViewSections, numberOfUpdatesExpected: updatesExpected) { update, value in
            switch update {
            case 1:
                //1. Expect to have only loader at lauch time
                XCTAssertEqual(value, [.loader])
                sut.askForNewDrinksIfNeeded(at: update - 1)
            case updatesExpected:
                XCTAssertEqual(value, [.drinks])
            default:
                sut.askForNewDrinksIfNeeded(at: update - 1)
            }
        }
    }
    
    func test_firstLoad_shouldReturnNoItemsIfNoDrinksAreConformToFilters() throws {
        let drinks = [Drink]()
        let networkProvider = makeNetworkProvider(with: drinks)
        let sut = makeSUT(networkProvider: networkProvider)
        
        //Expected to have no items section when no drinks are conform to filters
        //The logic should call all the response until it can, then the no items should be triggered
        let updatesExpected = 36 + 1
        
        sut.askForNewDrinksIfNeeded(at: 0)
        
        try awaitPublisher(sut.$tableViewSections, numberOfUpdatesExpected: updatesExpected) { update, value in
            switch update {
            case 1:
                //1. Expect to have only loader at lauch time
                XCTAssertEqual(value, [.loader])
            case updatesExpected:
                XCTAssertEqual(value, [.noItems])
            default:
                //During all the request only the loader should be load
                XCTAssertEqual(value, [.loader])
            }
        }
    }
    
    //MARK: Filters
    func test_setupNewFiltersFromFilterViewModel_shouldReturnExpectedFilters() throws {
        let drinks = makeFakeDrinks()
        let filter = makeFakeAlcoholicFilters()
        let networkProvider = makeNetworkProvider(with: drinks, alcoholicFiter: filter)
        let sut = makeSUT(networkProvider: networkProvider)
        
        //Providing filters data on network manager should populate filter section
        
        sut.firstLoad()

        try awaitPublisher(sut.$tableViewSections, numberOfUpdatesExpected: 2) { update, value in
            switch update {
            case 1:
                //1. Expect to have only loader at lauch time
                XCTAssertEqual(value, [.loader])
            case 2:
                //2. Expect to have both drinks and filter sections after first load succeeded
                XCTAssertEqual(value, [.filters, .drinks, .loader])
                self.filterTest(sut: sut)
            default:
                XCTFail("Expected only two returns")
            }
        }
    }
    
    private func filterTest(sut: MainViewModel) {
        let expectation = expectation(description: "Expect to get only alcoholic filter after apply tapped and refresh items")
        
        let filtersViewModel = sut.filtersViewModel
        var newFilters: [Filter]?
        filtersViewModel.filtersSubject
            .sink { newFiltersRetreived in
                newFilters = newFiltersRetreived
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        filtersViewModel.selectedFilter(at: IndexPath(row: 1, section: 0))
        filtersViewModel.applyTapped()
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(newFilters?.first { $0.type == .alcoholic }?.selectedValues, ["Alcoholic"])
    }
    
    
    //MARK: Image
    func test_setupImageToDrink_shouldRetrieveImage() throws {
        let drinks = makeFakeDrinks()
        let filter = makeFakeAlcoholicFilters()
        let networkProvider = makeNetworkProvider(with: drinks, alcoholicFiter: filter)
        let sut = makeSUT(networkProvider: networkProvider, imageProvider: ImageProviderSpy(data: "test".data(using: .utf8)))
        
        //Providing filters data on network manager should populate filter section
        
        sut.firstLoad()

        try awaitPublisher(sut.$tableViewSections, numberOfUpdatesExpected: 2) { update, value in
            switch update {
            case 1:
                //1. Expect to have only loader at lauch time
                XCTAssertEqual(value, [.loader])
            case 2:
                //2. Expect to have both drinks and filter sections after first load succeeded
                XCTAssertEqual(value, [.filters, .drinks, .loader])
                try! self.imageTest(sut: sut)
            default:
                XCTFail("Expected only two returns")
            }
        }
    }
    
    private func imageTest(sut: MainViewModel) throws {
        let expectation = expectation(description: "Expect to get image data from provider ")
        
        let drinkCellViewModel = sut.getDrinkViewModel(for: 0)
        
        var data: [Data?] = []
        let expectedCount = 2
        var counter = 1
        drinkCellViewModel.$drinkImageData
            .sink { imageData in
                data.append(imageData)
                if expectedCount == counter {
                    expectation.fulfill()
                }
                counter += 1
            }
            .store(in: &cancellables)

        let _ = drinkCellViewModel.getImageDataAndAskIfNeeded()

        wait(for: [expectation], timeout: 2.0)
        XCTAssertNil(data[0])
        XCTAssertNotNil(data[1])
    }
    
}

extension XCTestCase {
    @discardableResult
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        numberOfUpdatesExpected: Int,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line,
        onReceivedValue: @escaping (Int, T.Output) -> Void
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        var update: Int = 1
        let cancellable = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }
                
            },
            receiveValue: { value in
                result = .success(value)
                onReceivedValue(update, value)
                if numberOfUpdatesExpected == update {
                    expectation.fulfill()
                }
                update += 1
            }
        )
        

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}

//MARK: Providers
extension MainViewModelTests {
    private func makeSUT(networkProvider: NetworkProvider, imageProvider: ImageProvider? = nil) -> MainViewModel {
        let sut = MainViewModel(networkProvider: networkProvider, imageProvider: imageProvider ?? ImageProviderSpy(data: nil))
        sut.anyCancellables.forEach { $0.cancel() }
        return sut
    }
    
    private func makeNetworkProvider(with drinks: [Drink]? = nil, alcoholicFiter: [Alcoholic]? = nil, categoryFiter: [ShakeItApp.Category]? = nil, ingredientsFiter: [Ingredient]? = nil, glassFiter: [Glass]? = nil) -> NetworkProvider{
        let networkProvider = NetworkProviderSpy()
        networkProvider.drinks = drinks
        networkProvider.alcoholicFiter = alcoholicFiter
        networkProvider.categoryFiter = categoryFiter
        networkProvider.ingredientsFiter = ingredientsFiter
        networkProvider.glassFiter = glassFiter
        return networkProvider
    }
    
    private func makeFakeAlcoholicFilters() -> [Alcoholic] {
        [Alcoholic(strAlcoholic: "Alcoholic"), Alcoholic(strAlcoholic: "Non Alcoholic")]
    }
    
    private func makeFakeCategoryFilters() -> [ShakeItApp.Category] {
        [ShakeItApp.Category(strCategory: "Ordinary Drink")]
    }
    
    private func makeFakeIngredientsFilters() -> [Ingredient] {
        [Ingredient(strIngredient1: "Tequila")]
    }
    
    private func makeFakeGlassFilters() -> [Glass] {
        [Glass(strGlass: "Cocktail glass")]
    }
    
    private func makeFakeDrinks(count: Int = 1) -> [Drink] {
        let decoder = JSONDecoder()
        let drink = try! decoder.decode(Drink.self, from: drinkData)
        return Array(repeating: drink, count: count)
    }
}

class NetworkProviderSpy: NetworkProvider {
    var drinks: [Drink]?
    var alcoholicFiter: [Alcoholic]?
    var categoryFiter: [ShakeItApp.Category]?
    var ingredientsFiter: [Ingredient]?
    var glassFiter: [Glass]?
    
    func fetchData<T>(with apiElement: T) async -> Result<T.Output, ShakeItApp.ErrorData> where T : ShakeItApp.APIElement {
        if T.self == AlphabeticalDrinkAPI.self {
            if let drinks {
                return .success(                AlphabeticalDrinkAPI.Output(drinks: drinks) as! T.Output)
            } else {
                return .failure(.invalidData)
            }
        } else if T.self == AlcoholicListAPI.self {
            if let alcoholicFiter {
                return .success(AlcoholicListAPI.Output(drinks: alcoholicFiter) as! T.Output)
            } else {
                return .failure(.invalidData)
            }
        } else if T.self == CategoryListAPI.self {
            if let categoryFiter {
                return .success(CategoryListAPI.Output(drinks: categoryFiter) as! T.Output)
            } else {
                return .failure(.invalidData)
            }
        } else if T.self == IngredientsListAPI.self {
            if let ingredientsFiter {
                return .success(IngredientsListAPI.Output(drinks: ingredientsFiter) as! T.Output)
            } else {
                return .failure(.invalidData)
            }
        } else if T.self == GlassListAPI.self {
            if let glassFiter {
                return .success(GlassListAPI.Output(drinks: glassFiter) as! T.Output)
            } else {
                return .failure(.invalidData)
            }
        }
        
        return .failure(.decodingError)
    }
}

class ImageProviderSpy: ImageProvider {
    let data: Data?
    
    init(data: Data?) {
        self.data = data
    }
    
    func fetchImage(from url: URL) async -> Result<Data, ShakeItApp.ErrorData> {
        guard let data else { return .failure(.invalidURL) }
        return .success(data)
    }
}

fileprivate extension MainViewModelTests {
    private var drinkData: Data {
        """
        {\"idDrink\":\"11007\",\"strDrink\":\"Margarita\",\"strDrinkAlternate\":null,\"strTags\":\"IBA,ContemporaryClassic\",\"strVideo\":null,\"strCategory\":\"Ordinary Drink\",\"strIBA\":\"ContemporaryClassics\",\"strAlcoholic\":\"Alcoholic\",\"strGlass\":\"Cocktail glass\",\"strInstructions\":\"Rubtherimoftheglasswiththelimeslicetomakethesaltsticktoit.Takecaretomoistenonlytheouterrimandsprinklethesaltonit.Thesaltshouldpresenttothelipsoftheimbiberandnevermixintothecocktail.Shaketheotheringredientswithice,thencarefullypourintotheglass.\",\"strInstructionsES\":null,\"strInstructionsDE\":\"ReibenSiedenRanddesGlasesmitderLimettenscheibe,damitdasSalzdaranhaftet.AchtenSiedarauf,dassnurderäußereRandangefeuchtetwirdundstreuenSiedasSalzdarauf.DasSalzsolltesichaufdenLippendesGenießersbefindenundniemalsindenCocktaileinmischen.DieanderenZutatenmitEisschüttelnundvorsichtigindasGlasgeben.\",\"strInstructionsFR\":null,\"strInstructionsIT\":\"Strofinailbordodelbicchiereconlafettadilimeperfaraderireilsale.\\r\\nAverecuradiinumidiresoloilbordoesternoecospargeredisale.\\r\\nIlsaledovrebbepresentarsiallelabbradelbevitoreenonmescolarsimaialcocktail.\\r\\nShakerareglialtriingredienticonghiaccio,quindiversarlidelicatamentenelbicchiere.\",\"strInstructionsZH-HANS\":null,\"strInstructionsZH-HANT\":null,\"strDrinkThumb\":\"https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg\",\"strIngredient1\":\"Tequila\",\"strIngredient2\":\"Triplesec\",\"strIngredient3\":\"Limejuice\",\"strIngredient4\":\"Salt\",\"strIngredient5\":null,\"strIngredient6\":null,\"strIngredient7\":null,\"strIngredient8\":null,\"strIngredient9\":null,\"strIngredient10\":null,\"strIngredient11\":null,\"strIngredient12\":null,\"strIngredient13\":null,\"strIngredient14\":null,\"strIngredient15\":null,\"strMeasure1\":\"11/2oz\",\"strMeasure2\":\"1/2oz\",\"strMeasure3\":\"1oz\",\"strMeasure4\":null,\"strMeasure5\":null,\"strMeasure6\":null,\"strMeasure7\":null,\"strMeasure8\":null,\"strMeasure9\":null,\"strMeasure10\":null,\"strMeasure11\":null,\"strMeasure12\":null,\"strMeasure13\":null,\"strMeasure14\":null,\"strMeasure15\":null,\"strImageSource\":\"https://commons.wikimedia.org/wiki/File:Klassiche_Margarita.jpg\",\"strImageAttribution\":\"Cocktailmarler\",\"strCreativeCommonsConfirmed\":\"Yes\",\"dateModified\":\"2015-08-1814:42:59\"}
        """.data(using: .utf8)!
    }
}
