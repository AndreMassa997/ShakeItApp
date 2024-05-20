//
//  FilterCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import UIKit

final class FilterCell: UITableViewCell, CellReusable {
    private var viewModel: FilterCellViewModel!
    
    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkBoxButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        btn.setImage(UIImage(systemName: "circle"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let filterTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubviews() {
        self.viewContainer.addSubview(checkBoxButton)
        self.viewContainer.addSubview(filterTitleLabel)
        self.contentView.addSubview(viewContainer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            viewContainer.bottomAnchor.constraint(equalTo: checkBoxButton.bottomAnchor),
            
            checkBoxButton.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            checkBoxButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 30),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 30),

            filterTitleLabel.leftAnchor.constraint(equalTo: checkBoxButton.rightAnchor, constant: 5),
            filterTitleLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -15),
            filterTitleLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            filterTitleLabel.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: FilterCellViewModel) {
        self.viewModel = viewModel
        self.filterTitleLabel.text = viewModel.filterName
        self.isSelected = viewModel.isSelected
        setupButton(viewModel.isSelected)
    }
    
    private func setupButton(_ isSelected: Bool) {
        let image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        UIView.transition(with: checkBoxButton, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.checkBoxButton.setImage(image, for: .normal)
        })
    }
}

