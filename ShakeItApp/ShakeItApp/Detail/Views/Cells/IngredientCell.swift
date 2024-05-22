//
//  IngredientCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 21/05/24.
//

import UIKit

class IngredientCell: UICollectionViewCell, CellReusable {
    
    static let ingredientFont = UIFont.systemFont(ofSize: 14, weight: .light)
    static let measureFont = UIFont.systemFont(ofSize: 10, weight: .thin)
    static let marginRight: CGFloat = 10
    static let marginLeft: CGFloat = 10
    
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
        lbl.font = IngredientCell.ingredientFont
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let measureLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = IngredientCell.measureFont
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
        labelsStackView.addArrangedSubview(measureLabel)
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
            labelsStackView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: IngredientCell.marginLeft),
            labelsStackView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -IngredientCell.marginRight),
            labelsStackView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10),
        ])
        
        viewContainer.layer.cornerRadius = 20
    }
    
    func configure(with viewModel: IngredientViewModel) {
        self.viewContainer.backgroundColor = UIColor(hex: viewModel.backgroundColor)
        self.ingredientLabel.text = viewModel.ingredient
        self.measureLabel.text = viewModel.measure
    }
    
}
