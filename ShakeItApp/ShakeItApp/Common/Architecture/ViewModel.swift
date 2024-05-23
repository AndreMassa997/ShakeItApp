//
//  MVVMViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation
import Combine

typealias FullProviderConformance = ImageProviderConformance & NetworkProviderConformance

protocol ImageProviderConformance {
    var imageProvider: ImageProvider { get }
}

protocol NetworkProviderConformance {
    var networkProvider: NetworkProvider { get }
}

class ImageViewModel: BaseViewModel, ImageProviderConformance {
    let imageProvider: ImageProvider
    
    init(imageProvider: ImageProvider){
        self.imageProvider = imageProvider
    }
}

class FullViewModel: BaseViewModel, FullProviderConformance {
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
