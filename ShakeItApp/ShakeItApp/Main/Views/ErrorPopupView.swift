//
//  ErrorPopupView.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit
import Lottie

final class ErrorPopupView: UIView {
    @IBOutlet weak private var animationView: LottieAnimationView! {
        didSet {
            guard let path = Bundle.main.path(forResource: "error", ofType: "json") else {
                return
            }
            animationView.animation = LottieAnimation.filepath(path)
            animationView.loopMode = .loop
            animationView.play()
        }
    }
    
    @IBOutlet weak var viewContainer: UIView! {
        didSet {
            viewContainer.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    private var onButtonTapped: (() -> Void)?
    
    func configure(with title: String, buttonText: String = "MAIN.ERROR.RETRY".localized, onButtonTapped: @escaping () -> Void) {
        self.loadFromNib()
        self.onButtonTapped = onButtonTapped
        self.retryButton.setTitle(buttonText, for: .normal)
        self.textLabel.text = title
    }

    @IBAction func retryButtonTapped(_ sender: Any) {
        onButtonTapped?()
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
                       options: .curveEaseInOut) {
            self.alpha = 1
            self.center = view.center
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.alpha = 0
        }, completion: { [weak self] _ in
            self?.removeFromSuperview()
        })
    }
}
