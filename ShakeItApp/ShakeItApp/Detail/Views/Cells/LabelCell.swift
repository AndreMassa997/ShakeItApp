//
//  LabelCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import UIKit

final class LabelCell: BaseTableViewCell<LabelCellViewModel> {
    private let title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func configure(with viewModel: LabelCellViewModel) {
        super.configure(with: viewModel)
        self.title.text = viewModel.text
    }
    
    
    //MARK: Layout + UI
    override func setupLayout(){
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            contentView.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
        ])
    }
    
    override func addSubviews() {
        self.contentView.addSubview(title)
    }
    
    override func setupUI() {
        super.setupUI()
        title.textColor = .palette.secondaryLabelColor
    }
}


