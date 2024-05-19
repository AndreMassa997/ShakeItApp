//
//  DrinkCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit

final class DrinkCell: UITableViewCell, CellReusable {
    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let alcoholicTypeImageView: CircleImageView = {
        let iv = CircleImageView(image: UIImage(named: "placeholder"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return lbl
    }()
    
    private let ingredientsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return lbl
    }()
    
    private let labelsViewContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let arrowImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black.withAlphaComponent(0.3)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews() {
        labelsViewContainer.addArrangedSubview(titleLabel)
        labelsViewContainer.addArrangedSubview(ingredientsLabel)
        self.viewContainer.addSubview(alcoholicTypeImageView)
        self.viewContainer.addSubview(labelsViewContainer)
        self.viewContainer.addSubview(arrowImage)
        self.contentView.addSubview(viewContainer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            viewContainer.bottomAnchor.constraint(equalTo: alcoholicTypeImageView.bottomAnchor, constant: 5),
            
            alcoholicTypeImageView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            alcoholicTypeImageView.widthAnchor.constraint(equalToConstant: 50),
            alcoholicTypeImageView.heightAnchor.constraint(equalTo: alcoholicTypeImageView.widthAnchor),
            alcoholicTypeImageView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            
            labelsViewContainer.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 15),
            labelsViewContainer.leftAnchor.constraint(equalTo: alcoholicTypeImageView.rightAnchor, constant: 10),
            labelsViewContainer.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -15),
            
            arrowImage.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            arrowImage.heightAnchor.constraint(equalToConstant: 20),
            arrowImage.widthAnchor.constraint(equalTo: arrowImage.heightAnchor),
            arrowImage.leftAnchor.constraint(equalTo: labelsViewContainer.rightAnchor, constant: 10),
            arrowImage.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -5),
        ])
        
        viewContainer.layer.cornerRadius = 20
        viewContainer.layer.masksToBounds = false
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewContainer.layer.shadowRadius = 3
        viewContainer.layer.shadowOpacity = 0.01
    }
    
    func configure(with viewModel: DrinkCellViewModel) {
        viewContainer.backgroundColor = UIColor(hex: viewModel.backgroundColor)
        titleLabel.text = viewModel.drink.name.capitalized
        ingredientsLabel.text = viewModel.ingredientsString
    }

}
