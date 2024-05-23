//
//  DetailViewController.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 21/05/24.
//

import UIKit

final class DetailViewController: TableViewController<DetailViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.drink.name.capitalized
        setupTableView()
    }
    
    //Need to recalculate table view header when refreshing UI (orientation changed)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let headerView = DetailHeaderView(viewModel: viewModel.headerViewModel, frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 230)), nibLoadable: true)
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
            cell.configure(with: viewModel.labelCellViewModel)
            return cell
        case .ingredients:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: IngredientsCell.self)
            cell.configure(with: viewModel.ingredientsViewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeader(headerType: LabelHeader.self)
        header.configure(with: viewModel.getLabelHeaderViewModel(at: section))
        return header
    }
}

//MARK: - Layout + UI + Table view registrations
extension DetailViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(headerType: LabelHeader.self)
        tableView.register(cellType: LabelCell.self)
        tableView.register(cellType: IngredientsCell.self)
    }
}
