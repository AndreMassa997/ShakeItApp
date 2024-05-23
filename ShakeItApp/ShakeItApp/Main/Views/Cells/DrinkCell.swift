//
//  DrinkCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit
import Combine

final class DrinkCell: BaseTableViewCell<DrinkCellViewModel> {
    private var isSelectable: Bool = false
    
    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let alcoholicTypeImageView: CircleImageView = {
        let iv = CircleImageView(image: UIImage(named: "placeholder"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .light)
        lbl.textColor = .palette.blackLabelColor
        return lbl
    }()
    
    private let ingredientsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        lbl.textColor = .palette.blackLabelColor
        return lbl
    }()
    
    private let labelsViewContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let arrowImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right.circle"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black.withAlphaComponent(0.3)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        disableSelection()
    }
    
    override func configure(with viewModel: DrinkCellViewModel) {
        super.configure(with: viewModel)
        titleLabel.text = viewModel.drink.name.capitalized
        ingredientsLabel.text = viewModel.ingredientsString
        viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture)))
        
        guard let imageData = viewModel.getImageDataAndAskIfNeeded() else {
            //Add property listener to intercept data from API if no data are present
            bindProperties()
            return
        }
        enableSelection(with: imageData)
    }
    
    override func bindProperties() {
        viewModel.$drinkImageData
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] data in
                guard let data else { return }
                self?.enableSelection(with: data)
            }
            .store(in: &viewModel.anyCancellables)
    }
    
    override func addSubviews() {
        labelsViewContainer.addArrangedSubview(titleLabel)
        labelsViewContainer.addArrangedSubview(ingredientsLabel)
        viewContainer.addSubview(alcoholicTypeImageView)
        viewContainer.addSubview(labelsViewContainer)
        viewContainer.addSubview(arrowImage)
        contentView.addSubview(viewContainer)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            viewContainer.bottomAnchor.constraint(equalTo: alcoholicTypeImageView.bottomAnchor, constant: 10),
            
            alcoholicTypeImageView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            alcoholicTypeImageView.widthAnchor.constraint(equalToConstant: 50),
            alcoholicTypeImageView.heightAnchor.constraint(equalTo: alcoholicTypeImageView.widthAnchor),
            alcoholicTypeImageView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 15),
            
            labelsViewContainer.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 15),
            labelsViewContainer.leftAnchor.constraint(equalTo: alcoholicTypeImageView.rightAnchor, constant: 10),
            labelsViewContainer.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -15),
            
            arrowImage.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            arrowImage.heightAnchor.constraint(equalToConstant: 20),
            arrowImage.widthAnchor.constraint(equalTo: arrowImage.heightAnchor),
            arrowImage.leftAnchor.constraint(equalTo: labelsViewContainer.rightAnchor, constant: 10),
            arrowImage.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -15),
        ])
    }
    
    override func setupUI() {
        viewContainer.backgroundColor = .palette.mainColor
        viewContainer.layer.cornerRadius = 20
        viewContainer.layer.masksToBounds = false
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewContainer.layer.shadowRadius = 3
        viewContainer.layer.shadowOpacity = 0.01
    }
    
    private func enableSelection(with data: Data) {
        isSelectable = true
        UIView.transition(with: arrowImage, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.arrowImage.isHidden = false
        })
        
        UIView.transition(with: alcoholicTypeImageView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.alcoholicTypeImageView.image = UIImage(data: data)
        })
    }
    
    private func disableSelection() {
        arrowImage.isHidden = true
        alcoholicTypeImageView.image = UIImage(named: "placeholder")
        isSelectable = false
    }
    
    @objc private func tapGesture() {
        guard isSelectable, let viewModel else { return }
        viewModel.cellTapSubject.send(viewModel.drink)
    }
}
