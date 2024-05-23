//
//  MainViewModelTests.swift
//  ShakeItAppTests
//
//  Created by Andrea Massari on 23/05/24.
//

import XCTest
@testable import ShakeItApp

final class MainViewModelTests: XCTestCase {
    func test_firstLoad_shouldPopulateSectionsOnValidData() {
        let drinks = makeFakeDrinks()
        let filter = makeFakeAlcoholicFilters()
        let networkProvider = makeNetworkProvider(with: drinks, alcoholicFiter: filter)
        let sut = makeSUT(networkProvider: networkProvider)
        
        let expectation = XCTestExpectation(description: "Expect to have both filters and drinks section after first load succeeded")
        
        sut.firstLoad()
        
        var sections: [MainViewSection] = []
        sut.$tableViewSections
            .sink { sect in
                sections = sect
                expectation.fulfill()
            }
            .store(in: &sut.anyCancellables)
        
        wait(for: [expectation], timeout: 1.0)
                
        XCTAssert(sections.contains(.drinks))
        XCTAssert(sections.contains(.filters))
    }

    func test_firstLoad_shouldPopulateOnlyDrinksSectionsOnFiltersError() {
        let drinks = makeFakeDrinks()
        let networkProvider = makeNetworkProvider(with: drinks)
        let sut = makeSUT(networkProvider: networkProvider)
        
        let expectation = XCTestExpectation(description: "Expect to have only drinks sections after first load filters fails")
        sut.firstLoad()
        
        var sections: [MainViewSection] = []
        sut.$tableViewSections
            .sink { sect in
                sections = sect
                expectation.fulfill()
            }
            .store(in: &sut.anyCancellables)
        
        wait(for: [expectation], timeout: 1.0)
                
        XCTAssert(sections.contains(.drinks))
        XCTAssertFalse(sections.contains(.filters))
    }
    
    func test_firstLoad_shouldShowErrorOnInvalidResponse() {
        let errorNetworkProvider = makeNetworkProvider()
        let sut = makeSUT(networkProvider: errorNetworkProvider)
        
        let expectation1 = XCTestExpectation(description: "Expect to hide both filters and drinks section after first load fails for all requests")
        let expectation2 = XCTestExpectation(description: "Expect to trigger error subject")
        sut.firstLoad()
        
        var sections: [MainViewSection] = []
        sut.$tableViewSections
            .sink { sect in
                sections = sect
                expectation1.fulfill()
            }
            .store(in: &sut.anyCancellables)
        
        var error: String?
        sut.loadingErrorSubject
            .sink { err in
                error = err
                expectation2.fulfill()
            }
            .store(in: &sut.anyCancellables)
        
        wait(for: [expectation1, expectation2], timeout: 1.0)

        XCTAssertFalse(sections.contains(.drinks))
        XCTAssertFalse(sections.contains(.filters))
        XCTAssertNotNil(error)
    }
    
    func makeSUT(networkProvider: NetworkProvider) -> MainViewModel {
        let sut = MainViewModel(networkProvider: networkProvider, imageProvider: ImageProviderSpy())
        sut.anyCancellables.forEach { $0.cancel() }
        return sut
    }
    
    func makeNetworkProvider(with drinks: [Drink]? = nil, alcoholicFiter: [Alcoholic]? = nil, categoryFiter: [ShakeItApp.Category]? = nil, ingredientsFiter: [Ingredient]? = nil, glassFiter: [Glass]? = nil) -> NetworkProvider{
        let networkProvider = NetworkProviderSpy()
        networkProvider.drinks = drinks
        networkProvider.alcoholicFiter = alcoholicFiter
        networkProvider.categoryFiter = categoryFiter
        networkProvider.ingredientsFiter = ingredientsFiter
        networkProvider.glassFiter = glassFiter
        return networkProvider
    }
    
    func makeFakeAlcoholicFilters() -> [Alcoholic] {
        [Alcoholic(strAlcoholic: "Alcoholic")]
    }
    
    func makeFakeDrinks() -> [Drink] {
        let decoder = JSONDecoder()
        let drink = try! decoder.decode(Drink.self, from: drinkData)
        return [drink]
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
    func fetchImage(from url: URL) async -> Result<Data, ShakeItApp.ErrorData> {
        return .failure(.decodingError)
    }
}


fileprivate extension MainViewModelTests {
    private var drinkData: Data {
        """
        {\"idDrink\":\"11007\",\"strDrink\":\"Margarita\",\"strDrinkAlternate\":null,\"strTags\":\"IBA,ContemporaryClassic\",\"strVideo\":null,\"strCategory\":\"OrdinaryDrink\",\"strIBA\":\"ContemporaryClassics\",\"strAlcoholic\":\"Alcoholic\",\"strGlass\":\"Cocktailglass\",\"strInstructions\":\"Rubtherimoftheglasswiththelimeslicetomakethesaltsticktoit.Takecaretomoistenonlytheouterrimandsprinklethesaltonit.Thesaltshouldpresenttothelipsoftheimbiberandnevermixintothecocktail.Shaketheotheringredientswithice,thencarefullypourintotheglass.\",\"strInstructionsES\":null,\"strInstructionsDE\":\"ReibenSiedenRanddesGlasesmitderLimettenscheibe,damitdasSalzdaranhaftet.AchtenSiedarauf,dassnurderäußereRandangefeuchtetwirdundstreuenSiedasSalzdarauf.DasSalzsolltesichaufdenLippendesGenießersbefindenundniemalsindenCocktaileinmischen.DieanderenZutatenmitEisschüttelnundvorsichtigindasGlasgeben.\",\"strInstructionsFR\":null,\"strInstructionsIT\":\"Strofinailbordodelbicchiereconlafettadilimeperfaraderireilsale.\\r\\nAverecuradiinumidiresoloilbordoesternoecospargeredisale.\\r\\nIlsaledovrebbepresentarsiallelabbradelbevitoreenonmescolarsimaialcocktail.\\r\\nShakerareglialtriingredienticonghiaccio,quindiversarlidelicatamentenelbicchiere.\",\"strInstructionsZH-HANS\":null,\"strInstructionsZH-HANT\":null,\"strDrinkThumb\":\"https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg\",\"strIngredient1\":\"Tequila\",\"strIngredient2\":\"Triplesec\",\"strIngredient3\":\"Limejuice\",\"strIngredient4\":\"Salt\",\"strIngredient5\":null,\"strIngredient6\":null,\"strIngredient7\":null,\"strIngredient8\":null,\"strIngredient9\":null,\"strIngredient10\":null,\"strIngredient11\":null,\"strIngredient12\":null,\"strIngredient13\":null,\"strIngredient14\":null,\"strIngredient15\":null,\"strMeasure1\":\"11/2oz\",\"strMeasure2\":\"1/2oz\",\"strMeasure3\":\"1oz\",\"strMeasure4\":null,\"strMeasure5\":null,\"strMeasure6\":null,\"strMeasure7\":null,\"strMeasure8\":null,\"strMeasure9\":null,\"strMeasure10\":null,\"strMeasure11\":null,\"strMeasure12\":null,\"strMeasure13\":null,\"strMeasure14\":null,\"strMeasure15\":null,\"strImageSource\":\"https://commons.wikimedia.org/wiki/File:Klassiche_Margarita.jpg\",\"strImageAttribution\":\"Cocktailmarler\",\"strCreativeCommonsConfirmed\":\"Yes\",\"dateModified\":\"2015-08-1814:42:59\"}
        """.data(using: .utf8)!
    }
}
