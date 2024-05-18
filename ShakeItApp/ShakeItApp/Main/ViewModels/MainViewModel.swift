//
//  MainViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import Foundation

class MainViewModel {
    //Data from server for filters
    var filters: Filters?
    
    let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func requestFilters() {
        Task {
            filters = await loadFiltersValuesFromServer()
        }
    }
    
    ///Load filters in parallel using async let - await
    private func loadFiltersValuesFromServer() async -> Filters{
        async let categoryList = networkProvider.fetchData(with: CategoryListAPI())
        async let alcoholicList = networkProvider.fetchData(with: AlcoholicListAPI())
        async let ingredientsList = networkProvider.fetchData(with: IngredientsListAPI())
        async let glassList = networkProvider.fetchData(with: GlassListAPI())
        
        return await Filters(categoryList: categoryList, alcoholicList: alcoholicList, ingrendientsList: ingredientsList, glassList: glassList)
    }
}

struct Filters {
    var categoryList: Result<CategoryListAPI.Output, ErrorData>
    var alcoholicList: Result<AlcoholicListAPI.Output, ErrorData>
    var ingrendientsList: Result<IngredientsListAPI.Output, ErrorData>
    var glassList: Result<GlassListAPI.Output, ErrorData>
}
