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
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .clear
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
        self.title = "Shake it up"
        setupUI()
        bindProperties()
        viewModel.firstLoad()
        setupTableView()
        setupLayout()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .palette.mainBackgroundColor
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .palette.secondaryLabelColor
        self.navigationController?.navigationBar.barTintColor = .palette.mainBackgroundColor
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.palette.secondaryLabelColor]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.palette.secondaryLabelColor]

        let btn = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 25, height: 25)))
        btn.tintColor = .palette.secondaryLabelColor
        btn.setImage(UIImage(systemName: "gear"), for: .normal)
        btn.addTarget(self, action: #selector(self.showBottomSheetSettings), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItems = [rightBarButton]        
    }
    
    private func bindProperties() {
        viewModel.$tableViewSections
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &viewModel.anyCancellables)
        
        viewModel.loadingErrorSubject
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.showErrorPopup(error: error)
            }
            .store(in: &viewModel.anyCancellables)
        
        viewModel.tapOnDrink
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] drinkTapped in
                self?.goToDetailPage(drink: drinkTapped)
            }
            .store(in: &viewModel.anyCancellables)
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: FiltersCarouselView.self)
        tableView.register(headerType: LabelButtonHeader.self)
        tableView.register(cellType: DrinkCell.self)
        tableView.register(cellType: MainViewLoaderCell.self)
        tableView.register(cellType: NoItemsCell.self)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showErrorPopup(error: String?) {
        guard let error else { return }
        let popupView = ErrorPopupView(frame: self.view.frame)
        popupView.configure(with: error) { [weak self] in
            self?.viewModel.reloadDrinkFromError()
            popupView.hide()
        }
        popupView.show(in: self.view)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.tableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.tableViewSections[section] {
        case .filters, .noItems, .loader:
            return 1
        case .drinks:
            return viewModel.filteredDrinks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.tableViewSections[indexPath.section] {
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
        case .noItems:
            return tableView.dequeueReusableCell(for: indexPath, cellType: NoItemsCell.self)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.tableViewSections[indexPath.section] == .drinks else { return }
        viewModel.askForNewDrinksIfNeeded(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewSection = viewModel.tableViewSections[section]
        guard let headerData = tableViewSection.headerData else {
            return nil
        }
        let header = tableView.dequeueReusableHeader(headerType: LabelButtonHeader.self)
        header.configure(text: headerData.title, buttonText: headerData.buttonTitle, buttonImageNamed: headerData.buttonImageName) { [weak self] in
            if tableViewSection == .drinks {
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            } else if tableViewSection == .filters {
                self?.goToFiltersPage()
            }
        }
        return header
    }
}

//MARK: Filters
extension MainViewController {
    private func goToFiltersPage() {
        let filtersViewController = FiltersViewController(viewModel: viewModel.filtersViewModel)
        self.navigationController?.pushViewController(filtersViewController, animated: true)
    }
}

//MARK: Detail
extension MainViewController {
    private func goToDetailPage(drink: Drink) {
        let detailViewController = DetailViewController(viewModel: viewModel.getDetailViewModel(for: drink))
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: Settings
extension MainViewController {
    @objc private func showBottomSheetSettings(){
        let bottomSheet = UIAlertController(title: "MAIN.SETTINGS".localized, message: nil, preferredStyle: .actionSheet)
        bottomSheet.addAction(UIAlertAction(title: "MAIN.SETTINGS.THEME".localized, style: .default, handler: { [weak self] _ in
            self?.showThemeBottomSheetSettings()
        }))
        
        bottomSheet.addAction(UIAlertAction(title: "MAIN.SETTINGS.CANCEL".localized, style: .cancel))
        self.present(bottomSheet, animated: true)
    }
    
    private func showThemeBottomSheetSettings() {
        let bottomSheet = UIAlertController(title: "MAIN.SETTINGS.THEME".localized, message: nil, preferredStyle: .actionSheet)
        bottomSheet.addAction(UIAlertAction(title: "MAIN.SETTINGS.THEME.DARK".localized, style: .default, handler: { [weak self] _ in
            self?.setTheme(DarkPalette())
        }))
        
        bottomSheet.addAction(UIAlertAction(title: "MAIN.SETTINGS.THEME.LIGHT".localized, style: .default, handler: { [weak self] _ in
            self?.setTheme(LightPalette())
        }))
        
        bottomSheet.addAction(UIAlertAction(title: "MAIN.SETTINGS.THEME.AUTO".localized, style: .default, handler: { [weak self] _ in
            self?.setTheme(nil)
        }))
        
        bottomSheet.addAction(UIAlertAction(title: "MAIN.SETTINGS.CANCEL".localized, style: .cancel))
        self.present(bottomSheet, animated: true)
    }
    
    private func setTheme(_ palette: Palette?) {
        let hasChanged: Bool
        if let palette {
            hasChanged = AppPreferences.shared.setupUserPalette(newPalette: palette, storeNewPalette: true)
        } else {
            let mode: Palette = traitCollection.userInterfaceStyle == .dark ? DarkPalette() : LightPalette()
            hasChanged = AppPreferences.shared.setupUserPalette(newPalette: mode, deleteStoredValue: true)
        }
        
        if hasChanged {
            setupUI()
            self.tableView.reloadData()
        }
    }
}

