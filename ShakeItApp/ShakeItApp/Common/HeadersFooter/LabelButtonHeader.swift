//
//  LabelButtonHeader.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit

final class LabelButtonHeader: UITableViewHeaderFooterView, CellReusable {
    private let title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        return lbl
    }()
    
    private let rightButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return btn
    }()
    
    private var onButtonTapped: (() -> Void)?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .palette.mainBackgroundColor
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButtonImageToRight()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(title)
        self.contentView.addSubview(rightButton)
        self.rightButton.addTarget(self, action: #selector(self.rightButtonTapped), for: .touchUpInside)
    }
    
    func configure(text: String, buttonText: String, buttonImageNamed: String, onButtonTapped: @escaping (() -> Void)) {
        self.title.text = text
        self.rightButton.setTitle(buttonText, for: .normal)
        self.rightButton.setImage(UIImage(systemName: buttonImageNamed), for: .normal)
        self.onButtonTapped = onButtonTapped
        setupUI()
    }
    
    func setupButtonTextAnimated(text: String, buttonImageNamed: String) {
        UIView.transition(with: self.rightButton, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.rightButton.setTitle(text, for: .normal)
            self?.rightButton.setImage(UIImage(systemName: buttonImageNamed), for: .normal)
        })
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            rightButton.heightAnchor.constraint(equalToConstant: 30),
            rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.rightAnchor.constraint(lessThanOrEqualTo: rightButton.leftAnchor, constant: -15),
        ])
    }
    
    private func setupUI() {
        contentView.backgroundColor = .palette.mainBackgroundColor
        self.title.textColor = .palette.secondaryLabelColor
        self.rightButton.setTitleColor(.palette.secondaryLabelColor, for: .normal)
        self.rightButton.tintColor = .palette.secondaryLabelColor
    }
    
    private func setupButtonImageToRight() {
        rightButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        rightButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        rightButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    }
    
    @objc private func rightButtonTapped() {
        onButtonTapped?()
    }
}
