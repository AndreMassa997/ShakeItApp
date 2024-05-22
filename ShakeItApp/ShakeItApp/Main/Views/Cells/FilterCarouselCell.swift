//
//  FilterCarouselCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import UIKit

final class FilterCarouselCell: UICollectionViewCell, CellReusable {
    private let filterNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textColor = .palette.blackLabelColor
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let filterValuesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return lbl
    }()
    
    private let filterImageView: CircleImageView = {
        let iv = CircleImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
        backgroundColor = .clear
        addSubviews()
        setupLayout()
        setupUI()
    }
    
    func configure(with viewModel: FilterCarouselCellViewModel) {
        self.filterImageView.image = UIImage(named: viewModel.imageName)
        self.filterNameLabel.text = viewModel.filterName
                
        self.filterValuesLabel.text = "MAIN.SECTION.FILTER_SELECTION".localized(with: String(viewModel.selectedValuesCount), String(viewModel.allValuesCount))
    }
}

//- MARK: Layout and UI
extension FilterCarouselCell {
    private func addSubviews() {
        viewContainer.addArrangedSubview(filterNameLabel)
        viewContainer.addArrangedSubview(filterValuesLabel)
        contentView.addSubview(filterImageView)
        contentView.addSubview(viewContainer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            filterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            filterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            filterImageView.widthAnchor.constraint(equalToConstant: 40),
            filterImageView.heightAnchor.constraint(equalTo: filterImageView.widthAnchor),
            
            viewContainer.topAnchor.constraint(equalTo: filterImageView.bottomAnchor, constant: 5),
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupUI() {
        backgroundColor = .palette.mainColor
        filterValuesLabel.textColor = .palette.mainLabelColor

        layer.cornerRadius = 20
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.01
    }
}
