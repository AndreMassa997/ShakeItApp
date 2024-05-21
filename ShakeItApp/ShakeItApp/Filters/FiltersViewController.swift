//
//  FiltersViewController.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import UIKit

final class FiltersViewController: UIViewController {
    private let viewModel: FiltersViewModel
    
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
    
    private let applyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("FILTER.APPLY".localized, for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.7), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.backgroundColor = UIColor(hex: "#fdf9e6")
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Cannot load coder, no xib exists")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupNavigationBar()
        setupLayout()
        setupTableView()
        bindProperties()
        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
    }
    
    func bindProperties() {
        viewModel.filteringEnabled
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.applyButton.isEnabled = isEnabled
            }
            .store(in: &viewModel.anyCancellables)
    }
    
    private func addSubviews() {
        self.view.addSubview(tableView)
        self.view.addSubview(applyButton)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "MAIN.SECTION.FILTER_BY".localized
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = "BACK".localized
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -5),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 150),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(headerType: LabelButtonHeader.self)
        tableView.register(cellType: FilterCell.self)
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
        let buttonConfigurations = viewModel.getFilterHeaderValue(for: section)
        header.configure(text: viewModel.filters[section].type.name, buttonText: buttonConfigurations.text, buttonImageNamed: buttonConfigurations.imageName) { [weak self] in
            self?.viewModel.selectDeselectAllValues(at: section)
            self?.tableView.reloadSections(IndexSet(integer: section), with: .none)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedFilter(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        guard let header = tableView.headerView(forSection: indexPath.section) as? LabelButtonHeader else { return }
        
        let buttonConfigurations = viewModel.getFilterHeaderValue(for: indexPath.section)
        header.setupButtonTextAnimated(text: buttonConfigurations.text, buttonImageNamed: buttonConfigurations.imageName)
    }
}
