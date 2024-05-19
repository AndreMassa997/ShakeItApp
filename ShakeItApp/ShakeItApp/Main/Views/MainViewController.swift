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
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            tv.sectionHeaderTopPadding = 0
        }
        return tv
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
        setupTableView()
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
                self?.tableView.reloadData()
            })
            .store(in: &viewModel.anyCancellables)
        
        viewModel.$filteredDrinks
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &viewModel.anyCancellables)
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: FiltersCarouselView.self)
        tableView.register(headerType: MainViewHeader.self)
        tableView.register(cellType: DrinkCell.self)
        tableView.register(cellType: MainViewLoaderCell.self)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        MainViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableViewSection = MainViewSection[section]
        switch tableViewSection {
        case .filters, .loader:
            return 1
        case .drinks:
            return viewModel.filteredDrinks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewSection = MainViewSection[indexPath.section]
        switch tableViewSection {
        case .filters:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FiltersCarouselView.self)
            let filterCarouselViewModel = viewModel.filterCarouselViewModel
            cell.configure(with: filterCarouselViewModel)
            return cell
        case .drinks:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DrinkCell.self)
            let drinkViewModel = viewModel.getDrinkViewModel(for: indexPath.row)
            cell.configure(with: drinkViewModel)
            return cell
        case .loader:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MainViewLoaderCell.self)
            cell.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard MainViewSection[indexPath.section] == .drinks else { return }
        if viewModel.shouldLoadOtherItems(at: indexPath.row) {
            viewModel.loadDrinks()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != MainViewSection.loader.rawValue else {
            return nil
        }
        let header = tableView.dequeueReusableHeader(headerType: MainViewHeader.self)
        let tableViewSection = MainViewSection[section]
        header.configure(text: tableViewSection.title)
        return header
    }
}

