//
//  BaseTableViewCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import UIKit

class BaseTableViewCell<ViewModel: BaseViewModel>: UITableViewCell, CellReusable {
    private (set) var viewModel: ViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        selectionStyle = .none
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
