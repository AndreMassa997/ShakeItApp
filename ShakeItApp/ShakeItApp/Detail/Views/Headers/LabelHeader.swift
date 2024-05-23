//
//  LabelHeader.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import UIKit

final class LabelHeader: BaseHeaderView<LabelHeaderViewModel>{
    private let title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        return lbl
    }()

    override func configure(with viewModel: LabelHeaderViewModel) {
        super.configure(with: viewModel)
        self.title.text = viewModel.text
    }
    
    override func addSubviews() {
        self.contentView.addSubview(title)
    }
    
    override func setupLayout(){
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            contentView.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
        ])
    }
    
    override func setupUI() {
        contentView.backgroundColor = .clear
        title.textColor = .palette.secondaryLabelColor
    }
}
