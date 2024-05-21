//
//  CircleImageView.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit

class CircleImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }
}
