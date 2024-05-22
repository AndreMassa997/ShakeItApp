//
//  LabelHeader.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import UIKit

final class LabelHeader: UITableViewHeaderFooterView, CellReusable {
    private let title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        return lbl
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(title)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        self.title.text = text
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            contentView.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
        ])
        
        title.textColor = .palette.secondaryLabelColor
    }
    
}
