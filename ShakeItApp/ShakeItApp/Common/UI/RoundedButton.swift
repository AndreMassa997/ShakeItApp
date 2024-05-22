//
//  RoundedButton.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import UIKit

final class RoundedButton: UIButton {
    private let enabledBackgroundColor: UIColor = .palette.secondaryColor
    private let disabledBackgroundColor: UIColor = .palette.mainColor
    private let titleColor: UIColor = .palette.blackLabelColor
    private let titleFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .light)
    
    override var isEnabled: Bool {
        didSet {
            refreshBackgroundColor()
        }
    }
    
    convenience init(text: String) {
        self.init(type: .system)
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        setTitleColor(.black.withAlphaComponent(0.7), for: .normal)
        layer.cornerRadius = 20
        refreshBackgroundColor()
    }
    
    private func refreshBackgroundColor() {
        self.backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
    }
}
