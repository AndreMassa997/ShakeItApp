//
//  DetailViewController.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 21/05/24.
//

import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    
    @IBOutlet weak var headerViewContainer: UIView! {
        didSet {
            headerViewContainer.backgroundColor = UIColor(hex: "#fdf9e6")
            headerViewContainer.layer.cornerRadius = 20
        }
    }
        
    @IBOutlet weak var drinkImageView: CircleImageView!
    
    @IBOutlet weak var alcoholicTitle: UILabel!
    @IBOutlet weak var alcoholicLabel: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var glassTitle: UILabel!
    @IBOutlet weak var glassLabel: UILabel!
    
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsTitle: UILabel!

    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupData()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = viewModel.drink.name.capitalized
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = "BACK".localized
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
    }
    
    private func setupData() {
        self.alcoholicLabel.text = viewModel.drink.alcoholic.capitalized
        self.categoryLabel.text = viewModel.drink.category.capitalized
        self.glassLabel.text = viewModel.drink.glass.capitalized
        self.alcoholicTitle.text = "DETAIL.ALCOHOLIC".localized
        self.categoryTitle.text = "DETAIL.CATEGORIES".localized
        self.ingredientsTitle.text = "DETAIL.INGREDIENTS".localized
        self.glassTitle.text = "DETAIL.GLASS".localized
        self.descriptionTitle.text = "DETAIL.DESCRIPTION".localized
        
        if let data = viewModel.drink.imageData {
            drinkImageView.image = UIImage(data: data)
        } else {
            drinkImageView.image = UIImage(named: "placeholder")
        }
    }
}
