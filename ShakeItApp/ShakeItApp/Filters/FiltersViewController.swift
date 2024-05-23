//
//  FiltersViewController.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import UIKit

final class FiltersViewController: TableViewController<FiltersViewModel> {
    private let applyButton: RoundedButton = {
        let btn = RoundedButton(text: "FILTER.APPLY".localized)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MAIN.SECTION.FILTER_BY".localized
        setupTableView()
        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(applyButton)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -5),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            applyButton.widthAnchor.constraint(equalToConstant: 150),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func bindProperties() {
        viewModel.filteringEnabled
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.applyButton.isEnabled = isEnabled
            }
            .store(in: &viewModel.anyCancellables)
        
        viewModel.buttonHeaderTapped
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
            .store(in: &viewModel.anyCancellables)
    }
    
    @objc private func applyTapped() {
        viewModel.applyTapped()
        navigationController?.popViewController(animated: true)
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filters[section].allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.getFilterCellViewModel(for: indexPath)
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FilterCell.self)
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeader(headerType: LabelButtonHeader.self)
        header.configure(with: viewModel.getFilterHeaderViewModel(for: section))
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedFilter(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        guard let header = tableView.headerView(forSection: indexPath.section) as? LabelButtonHeader else { return }
        let headerViewModel = viewModel.getHeaderButtonData(at: indexPath.section)
        header.setupButtonTextAnimated(text: headerViewModel.buttonText, buttonImageNamed: headerViewModel.imageName)
    }
}

//MARK: - Layout and UI + Table view registrations
extension FiltersViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(headerType: LabelButtonHeader.self)
        tableView.register(cellType: FilterCell.self)
    }
}
