//
//  BaseHeaderView.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 23/05/24.
//

import UIKit

class BaseHeaderView<ViewModel: BaseViewModel>: UITableViewHeaderFooterView, CellReusable {
    private(set) var viewModel: ViewModel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
    
    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func setupUI() {
        backgroundColor = .clear
    }
    
    func addSubviews() {}
    func setupLayout() {}
}
