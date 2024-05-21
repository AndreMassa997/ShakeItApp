//
//  IngredientCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 21/05/24.
//

import UIKit

class IngredientCell: UICollectionViewCell, CellReusable {
    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let ingredientLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let quantityLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .thin)
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews() {
        labelsStackView.addArrangedSubview(ingredientLabel)
        labelsStackView.addArrangedSubview(quantityLabel)
        self.contentView.addSubview(viewContainer)
        self.contentView.addSubview(labelsStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            labelsStackView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            labelsStackView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            labelsStackView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            labelsStackView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10),
        ])
        
        viewContainer.layer.cornerRadius = 20
    }
    
    func configure(with viewModel: IngredientViewModel) {
        self.viewContainer.backgroundColor = UIColor(hex: viewModel.backgroundColor)
        self.ingredientLabel.text = viewModel.ingredient
        self.quantityLabel.text = viewModel.measure
    }
    
}
