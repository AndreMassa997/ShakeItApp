//
//  ErrorPopupViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 23/05/24.
//

import Combine

final class ErrorPopupViewModel: BaseViewModel {
    let title: String
    let buttonText: String
    
    let buttonTapped = PassthroughSubject<Void, Never>()
    
    init(title: String, buttonText: String) {
        self.title = title
        self.buttonText = buttonText
    }
}
