//
//  MVVMViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation
import Combine

class NetworkViewModel: BaseViewModel {
    let networkProvider: NetworkProvider
    let imageProvider: ImageProvider
    
    init(networkProvider: NetworkProvider, imageProvider: ImageProvider){
        self.networkProvider = networkProvider
        self.imageProvider = imageProvider
    }
}

class BaseViewModel: ObservableObject {
    var anyCancellables: Set<AnyCancellable> = Set()
}
