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
        let sut = makeSUT(networkProvider: NetworkProviderSpy(drinks: drinks))
        
        let expectation = XCTestExpectation(description: "Expect to have valid properties after first load")
        sut.firstLoad()
        
        sut.$tableViewSections
            .sink { sections in
                expectation.fulfill()
            }
            .store(in: &sut.anyCancellables)
        
        wait(for: [expectation], timeout: 1.0)
                
        XCTAssertEqual(sut.filteredDrinks.map(\.id), drinks.map(\.id))
    }
    
    func makeSUT(networkProvider: NetworkProvider) -> MainViewModel {
        let sut = MainViewModel(networkProvider: networkProvider, imageProvider: ImageProviderSpy())
        return sut
    }
    
    func makeFakeFilters() -> [Filter] {
        [Filter(.alcoholic, values: [])].compactMap{ $0 }
    }
    
    func makeFakeDrinks() -> [Drink] {
        let decoder = JSONDecoder()
        let drink = try! decoder.decode(Drink.self, from: drinkData)
        return [drink]
    }
}

class NetworkProviderSpy: NetworkProvider {
    let drinks: [Drink]?
    
    init(drinks: [Drink]) {
        self.drinks = drinks
    }
    
    func fetchData<T>(with apiElement: T) async -> Result<T.Output, ShakeItApp.ErrorData> where T : ShakeItApp.APIElement {
        if T.self == AlphabeticalDrinkAPI.self {
            if let drinks {
                return .success(                AlphabeticalDrinkAPI.Output(drinks: drinks) as! T.Output)
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
