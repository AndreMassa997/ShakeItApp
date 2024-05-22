//
//  LabelCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import UIKit

final class LabelCell: UITableViewCell, CellReusable {
    private let title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupLayout()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String?) {
        self.title.text = text
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            contentView.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
        ])
    }
    
    private func addSubviews() {
        self.contentView.addSubview(title)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        title.textColor = .palette.secondaryLabelColor
    }
}


