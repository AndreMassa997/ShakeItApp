//
//  MainViewLoaderCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit
import Lottie

final class MainViewLoaderCell: BaseTableViewCell<BaseViewModel> {
    private let animatedView: LottieAnimationView = {
        let av = LottieAnimationView(name: "loader")
        av.contentMode = .scaleAspectFit
        av.loopMode = .loop
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        animatedView.play()
    }
    
    override func addSubviews() {
        self.contentView.addSubview(animatedView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            animatedView.widthAnchor.constraint(equalToConstant: 100),
            animatedView.heightAnchor.constraint(equalToConstant: 100),
            animatedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            animatedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animatedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
