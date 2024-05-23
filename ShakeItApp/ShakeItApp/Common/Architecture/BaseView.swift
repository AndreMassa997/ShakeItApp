//
//  BaseView.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 23/05/24.
//

import UIKit

class BaseView<ViewModel: BaseViewModel>: UIView {
    let viewModel: ViewModel
    
    init(viewModel: ViewModel, frame: CGRect, nibLoadable: Bool = false) {
        self.viewModel = viewModel
        super.init(frame: frame)
        if nibLoadable {
            loadFromNib()
        }
        setupUI()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData() {}
    func setupUI() {}
}
