//
//  MainViewController.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 17/05/24.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    
    private let filtersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Cannot load coder, no xib exists")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        bindProperties()
        setupNavigationBar()
        viewModel.firstLoad()
        setupFiltersView()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Shake It App"
    }
    
    private func bindProperties() {
        viewModel.$selectedFilters
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateFilterView()
            })
            .store(in: &viewModel.anyCancellables)
    }
    
    private func setupFiltersView() {
        self.view.addSubview(filtersCollectionView)
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        filtersCollectionView.register(cellType: FilterCell.self)
    }
    
    private func updateFilterView() {
        filtersCollectionView.reloadData()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            filtersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filtersCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            filtersCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            filtersCollectionView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
}

//MARK: Filters Collection View
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.selectedFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(for: indexPath, cellType: FilterCell.self)
        let filterCellViewModel = FilterCellViewModel(filter: viewModel.selectedFilters[indexPath.row])
        filterCell.configure(with: filterCellViewModel)
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

