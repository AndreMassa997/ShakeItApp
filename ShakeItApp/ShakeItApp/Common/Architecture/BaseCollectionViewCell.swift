//
//  BaseCollectionViewCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 23/05/24.
//

import UIKit

class BaseCollectionViewCell<ViewModel: BaseViewModel>: UICollectionViewCell, CellReusable {
    var viewModel: ViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubviews()
        setupLayout()
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = .clear
    }
    
    //Mandatory override of this method to set view model
    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func bindProperties() {}
    func addSubviews() {}
    func setupLayout() {}
}
