//
//  DrinkCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit

final class DrinkCell: UITableViewCell, CellReusable {
    private let alcoholicTypeImageView: CircleImageView = {
        let iv = CircleImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private let ingredientsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        return lbl
    }()
    
    private let labelsViewContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews() {
        labelsViewContainer.addArrangedSubview(titleLabel)
        labelsViewContainer.addArrangedSubview(ingredientsLabel)
        self.contentView.addSubview(alcoholicTypeImageView)
    }
    
    private func setupLayout() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            alcoholicTypeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            alcoholicTypeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            alcoholicTypeImageView.widthAnchor.constraint(equalToConstant: 40),
            alcoholicTypeImageView.heightAnchor.constraint(equalTo: alcoholicTypeImageView.widthAnchor),
            alcoholicTypeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            labelsViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelsViewContainer.leftAnchor.constraint(equalTo: alcoholicTypeImageView.rightAnchor, constant: 10),
            labelsViewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            labelsViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 0.01
    }
    
    func configure(with viewModel: DrinkCellViewModel) {
        contentView.backgroundColor = UIColor(hex: viewModel.backgroundColor)
        titleLabel.text = viewModel.drink.name.capitalized
        ingredientsLabel.text = viewModel.ingredientsString
    }

}
