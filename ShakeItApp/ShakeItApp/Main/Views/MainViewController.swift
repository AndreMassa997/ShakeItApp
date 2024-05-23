//
//  MainViewController.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 17/05/24.
//

import UIKit
import Combine

final class MainViewController: TableViewController<MainViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shake it up"
        setupTableView()
        viewModel.firstLoad()
    }
    
    override func bindProperties() {
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
        
        viewModel.buttonHeaderSubject
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                if self.viewModel.tableViewSections[index] == .drinks {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                } else if self.viewModel.tableViewSections[index] == .filters {
                    self.goToFiltersPage()
                }
            }
            .store(in: &viewModel.anyCancellables)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let btn = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 25, height: 25)))
        btn.tintColor = .palette.secondaryLabelColor
        btn.setImage(UIImage(systemName: "gear"), for: .normal)
        btn.addTarget(self, action: #selector(self.showBottomSheetSettings), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItems = [rightBarButton]
    }
    
//MARK: Error popup
    private func showErrorPopup(error: String?) {
        guard let error else { return }
        let errorViewModel = ErrorPopupViewModel(title: error, buttonText: "MAIN.ERROR.RETRY".localized)
        let popupView = ErrorPopupView(viewModel: errorViewModel, frame: self.view.frame, nibLoadable: true)
        
        popupView.show(in: self.view)
        
        errorViewModel.buttonTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.reloadDrinkFromError()
                popupView.hide()
            }
            .store(in: &viewModel.anyCancellables)
        
    }
}

//MARK: - TableView delegates and datasource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: FiltersCarouselView.self)
        tableView.register(headerType: LabelButtonHeader.self)
        tableView.register(cellType: DrinkCell.self)
        tableView.register(cellType: MainViewLoaderCell.self)
        tableView.register(cellType: NoItemsCell.self)
    }
    
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
            return tableView.dequeueReusableCell(for: indexPath, cellType: MainViewLoaderCell.self)
        case .noItems:
            return tableView.dequeueReusableCell(for: indexPath, cellType: NoItemsCell.self)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.tableViewSections[indexPath.section] == .drinks else { return }
        viewModel.askForNewDrinksIfNeeded(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerViewModel = viewModel.getHeaderViewModel(at: section) else {
            return nil
        }
        let header = tableView.dequeueReusableHeader(headerType: LabelButtonHeader.self)
        header.configure(with: headerViewModel)
        return header
    }
}

//MARK: - Filters
extension MainViewController {
    private func goToFiltersPage() {
        let filtersViewController = FiltersViewController(viewModel: viewModel.filtersViewModel)
        self.navigationController?.pushViewController(filtersViewController, animated: true)
    }
}

//MARK: - Detail
extension MainViewController {
    private func goToDetailPage(drink: Drink) {
        let detailViewController = DetailViewController(viewModel: viewModel.getDetailViewModel(for: drink))
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - Settings
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

