//
//  DetailViewController.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 21/05/24.
//

import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .clear
        if #available(iOS 15.0, *) {
            tv.sectionHeaderTopPadding = 0
        }
        return tv
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupUI()
        setupTableView()
    }
    
    //Need to recalculate table view header when refreshing UI (orientation changed)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let headerView = DetailHeaderView(viewModel: viewModel.headerViewModel, frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 230)))
        tableView.tableHeaderView = headerView
    }
    
    deinit {
        print("Deinit detail view controller")
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        DetailViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch DetailViewSection.allCases[indexPath.section] {
        case .instructions:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LabelCell.self)
            cell.configure(with: viewModel.instructionText)
            return cell
        case .ingredients:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: IngredientsCell.self)
            cell.configure(with: viewModel.ingredientsViewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeader(headerType: LabelHeader.self)
        header.configure(with: DetailViewSection.allCases[section].headerName)
        return header
    }
}

//MARK: - Layout + UI + Table view registrations
extension DetailViewController {
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupUI() {
        self.title = viewModel.drink.name.capitalized
        self.view.backgroundColor = .palette.mainBackgroundColor
    }
    
    private func addSubviews() {
        self.view.addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(headerType: LabelHeader.self)
        tableView.register(cellType: LabelCell.self)
        tableView.register(cellType: IngredientsCell.self)
    }
}
