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
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let filterValuesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let viewContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
        viewContainer.addArrangedSubview(filterNameLabel)
        viewContainer.addArrangedSubview(filterValuesLabel)
        self.contentView.addSubview(viewContainer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
        
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
    }
    
    func configure(with viewModel: FilterCellViewModel) {
        self.backgroundColor = UIColor(hex: viewModel.backgroundColor)
        self.filterNameLabel.text = viewModel.filterName
        
        let boldAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 10, weight: .bold)]
        let regularAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 10, weight: .regular)]
        
        let mutableAttrString = NSMutableAttributedString(string: "\(viewModel.selectedValuesCount)", attributes: boldAttributes)
        mutableAttrString.append(NSAttributedString(string: " di ", attributes: regularAttributes))
        mutableAttrString.append(NSAttributedString(string: "\(viewModel.allValuesCount)", attributes: boldAttributes))
        mutableAttrString.append(NSAttributedString(string: "\nselezionati", attributes: regularAttributes))
        
        self.filterValuesLabel.attributedText = mutableAttrString
    }
}
