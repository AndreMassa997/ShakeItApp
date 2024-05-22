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
        
        let backButtonItem = UIBarButtonItem(title: "BACK".localized, style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem

        let btn = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 25, height: 25)))
        btn.tintColor = .palette.secondaryLabelColor
        btn.setImage(UIImage(systemName: "gear"), for: .normal)
        btn.addTarget(self, action: #selector(self.showBottomSheetSettings), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItems = [rightBarButton]        
    }
    
    private func bindProperties() {
        viewModel.$tableViewSections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &viewModel.anyCancellables)
        
        viewModel.loadingErrorSubject
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showErrorPopup(error: error)
            }
            .store(in: &viewModel.anyCancellables)
        
        viewModel.tapOnDrink
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
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
        self.showBottomSheet(with: "MAIN.SETTINGS".localized, and: [
            ("MAIN.SETTINGS.THEME".localized, self.showThemeBottomSheetSettings()),
            ("MAIN.SETTINGS.LANGUAGE".localized, self.showLanguageBottomSheetSettings())
        ])
    }
    
    private func showThemeBottomSheetSettings() -> () -> Void {
        return { [weak self] in
            guard let self else { return }
            self.showBottomSheet(with: "MAIN.SETTINGS.THEME".localized, and: [
                ("MAIN.SETTINGS.THEME.DARK".localized, self.setupTheme(DarkPalette())),
                ("MAIN.SETTINGS.THEME.LIGHT".localized, self.setupTheme(LightPalette())),
                ("MAIN.SETTINGS.AUTO".localized, self.setupTheme(nil))
            ])
        }
    }
    
    private func showLanguageBottomSheetSettings() -> () -> Void {
        return { [weak self] in
            guard let self else { return }
            self.showBottomSheet(with: "MAIN.SETTINGS.LANGUAGE".localized, and: [
                ("MAIN.SETTINGS.LANGUAGE.ITA".localized, self.setupLanguage("it")),
                ("MAIN.SETTINGS.LANGUAGE.ENG".localized, self.setupLanguage("en")),
                ("MAIN.SETTINGS.AUTO".localized, self.setupLanguage(nil))
            ])
        }
    }
    
    private func showBottomSheet(with title: String, and elements: [(title: String, action: () -> Void)]) {
        let bottomSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        elements.forEach { element in
            bottomSheet.addAction(UIAlertAction(title: element.title, style: .default, handler: { _ in
                element.action()
            }))
        }
        
        bottomSheet.addAction(UIAlertAction(title: "MAIN.SETTINGS.CANCEL".localized, style: .cancel))
        self.present(bottomSheet, animated: true)
    }
    
    private func setupTheme(_ palette: Palette?) -> () -> Void {
        return { [weak self] in
            let hasChanged: Bool
            if let palette {
                hasChanged = AppPreferences.shared.setupUserPalette(newPalette: palette, storeNewPalette: true)
            } else {
                let mode: Palette = self?.traitCollection.userInterfaceStyle == .dark ? DarkPalette() : LightPalette()
                hasChanged = AppPreferences.shared.setupUserPalette(newPalette: mode, deleteStoredValue: true)
            }
            self?.reloadViewsIfNeeded(hasChanged)
        }
    }
    
    private func setupLanguage(_ code: String?) -> () -> Void {
        return { [weak self] in
            self?.reloadViewsIfNeeded(AppPreferences.shared.setupLanguage(languageCode: code))
        }
    }
    
    private func reloadViewsIfNeeded(_ hasChanged: Bool) {
        if hasChanged {
            setupUI()
            self.tableView.reloadData()
        }
    }
}

