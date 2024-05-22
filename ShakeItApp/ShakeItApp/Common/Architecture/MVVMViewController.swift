//
//  MVVMViewController.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import Foundation

import UIKit

class MVVMViewController<ViewModel: BaseViewModel>: UIViewController{
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Cannot load coder")
    }
    
    private var backgroundColor: UIColor {
        .palette.mainBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        bindProperties()
        setupUI()
        setupLayout()
    }
    
    func setupUI() {
        view.backgroundColor = backgroundColor
        setupNavigationBar()
    }
  
    func setupNavigationBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .palette.secondaryLabelColor
        self.navigationController?.navigationBar.barTintColor = .palette.mainBackgroundColor
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.palette.secondaryLabelColor]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.palette.secondaryLabelColor]
        
        let backButtonItem = UIBarButtonItem(title: "BACK".localized, style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
    }
    
    //Abstract methods
    func bindProperties() {}
    func addSubviews() {}
    func setupLayout() {}
}
