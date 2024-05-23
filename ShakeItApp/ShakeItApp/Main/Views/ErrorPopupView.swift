//
//  ErrorPopupView.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit
import Lottie

final class ErrorPopupView: BaseView<ErrorPopupViewModel> {
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var retryButton: UIButton!
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
    
    @IBOutlet weak private var viewContainer: UIView! {
        didSet {
            viewContainer.layer.cornerRadius = 20
        }
    }
        
    override func setupUI() {
        retryButton.setTitle(viewModel.buttonText, for: .normal)
        textLabel.text = viewModel.title
    }

    @IBAction func retryButtonTapped(_ sender: Any) {
        viewModel.buttonTapped.send()
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
