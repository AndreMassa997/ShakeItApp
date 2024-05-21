//
//  MainViewLoaderCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit
import Lottie

final class MainViewLoaderCell: UITableViewCell, CellReusable {
    private let animatedView: LottieAnimationView = {
        let av = LottieAnimationView(name: "loader")
        av.contentMode = .scaleAspectFit
        av.loopMode = .loop
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(animatedView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            animatedView.widthAnchor.constraint(equalToConstant: 100),
            animatedView.heightAnchor.constraint(equalToConstant: 100),
            animatedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            animatedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animatedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func startAnimating() {
        animatedView.play()
    }
}
