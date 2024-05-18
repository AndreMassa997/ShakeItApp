//
//  FilterCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import UIKit

final class FilterCell: UICollectionViewCell, CellReusable {
    private let filterNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let filterValuesLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let viewContainer = UIStackView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews() {
        viewContainer.addArrangedSubview(filterNameLabel)
        viewContainer.addArrangedSubview(filterValuesLabel)
        self.contentView.addSubview(viewContainer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            contentView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
        ])
    }
    
    func configure() {
        
    }
}
