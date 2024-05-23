//
//  LabelButtonHeaderViewModel.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 23/05/24.
//

import Combine

final class LabelButtonHeaderViewModel: BaseViewModel {
    let titleText: String
    let buttonText: String
    let imageName: String
    let buttonTappedSubject = PassthroughSubject<Void, Never>()

    init(titleText: String, buttonText: String, imageName: String) {
        self.titleText = titleText
        self.buttonText = buttonText
        self.imageName = imageName
    }
}
