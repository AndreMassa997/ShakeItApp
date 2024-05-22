//
//  DetailHeaderView.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import UIKit

final class DetailHeaderView: UIView {
    private let viewModel: DetailHeaderViewModel
    
    @IBOutlet private weak var viewContainer: UIView! {
        didSet {
            viewContainer.backgroundColor = UIColor(hex: "#fdf9e6")
            viewContainer.layer.cornerRadius = 20
        }
    }
    @IBOutlet private weak var alcoholicTitle: UILabel!
    @IBOutlet private weak var alcoholicLabel: UILabel!
    @IBOutlet private weak var categoryTitle: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var glassTitle: UILabel!
    @IBOutlet private weak var glassLabel: UILabel!
    @IBOutlet weak var drinkImageView: CircleImageView!
    
    init(viewModel: DetailHeaderViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.loadFromNib()
        self.setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupData() {
        self.alcoholicTitle.text = "DETAIL.ALCOHOLIC".localized
        self.alcoholicLabel.text = viewModel.alcoholic.capitalized

        self.categoryTitle.text = "DETAIL.CATEGORY".localized
        self.categoryLabel.text = viewModel.category.capitalized
        
        self.glassTitle.text = "DETAIL.GLASS".localized
        self.glassLabel.text = viewModel.glass.capitalized
        
        if let data = viewModel.imageData {
            drinkImageView.image = UIImage(data: data)
        } else {
            drinkImageView.image = UIImage(named: "placeholder")
        }
    }
    
    
}
