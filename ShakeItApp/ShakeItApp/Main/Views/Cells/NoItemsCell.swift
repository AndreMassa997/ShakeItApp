//
//  NoItemsCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 20/05/24.
//

import UIKit
import Lottie

final class NoItemsCell: UITableViewCell, CellReusable {
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        lbl.textColor = .palette.secondaryLabelColor
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "MAIN.NO_DRINKS".localized
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let animatedView: LottieAnimationView = {
        let av = LottieAnimationView(name: "no_data")
        av.contentMode = .scaleAspectFit
        av.loopMode = .loop
        av.translatesAutoresizingMaskIntoConstraints = false
        av.play()
        return av
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(animatedView)
        self.contentView.addSubview(titleLabel)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            animatedView.widthAnchor.constraint(equalToConstant: 200),
            animatedView.heightAnchor.constraint(equalToConstant: 200),
            animatedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animatedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(equalTo: animatedView.topAnchor, constant: 20)
        ])
    }
}
