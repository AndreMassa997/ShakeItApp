//
//  MVVMViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation
import Combine

class MVVMViewModel: ObservableObject {
    let networkProvider: NetworkProvider
    let imageProvider: ImageProvider
    var anyCancellables: Set<AnyCancellable> = Set()
    
    init(networkProvider: NetworkProvider, imageProvider: ImageProvider){
        self.networkProvider = networkProvider
        self.imageProvider = imageProvider
    }
}
