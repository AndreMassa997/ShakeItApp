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
    
    private let checkBoxView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .palette.secondaryColor
        return iv
    }()
    
    private let filterTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .palette.secondaryLabelColor
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with viewModel: FilterCellViewModel) {
        self.viewModel = viewModel
        self.filterTitleLabel.text = viewModel.filterName
        setupButton(viewModel.isSelected)
    }
    
    private func setupButton(_ isSelected: Bool) {
        let image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        UIView.transition(with: checkBoxView, duration: 0.3, options: .transitionFlipFromRight, animations: { [weak self] in
            self?.checkBoxView.image = image
        })
    }
}

//MARK: - Layout and UI
extension FilterCell {
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func addSubviews() {
        self.viewContainer.addSubview(checkBoxView)
        self.viewContainer.addSubview(filterTitleLabel)
        self.contentView.addSubview(viewContainer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            viewContainer.bottomAnchor.constraint(equalTo: checkBoxView.bottomAnchor),
            
            checkBoxView.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            checkBoxView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            checkBoxView.widthAnchor.constraint(equalToConstant: 25),
            checkBoxView.heightAnchor.constraint(equalToConstant: 25),

            filterTitleLabel.leftAnchor.constraint(equalTo: checkBoxView.rightAnchor, constant: 10),
            filterTitleLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -15),
            filterTitleLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            filterTitleLabel.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor)
        ])
    }
}

