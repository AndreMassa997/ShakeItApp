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
    
    @IBOutlet weak var instructionsTitle: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
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
        setupIngredientsCV()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = viewModel.drink.name.capitalized
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = "BACK".localized
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
    }
    
    private func setupIngredientsCV() {
        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.delegate = self
        ingredientsCollectionView.register(cellType: IngredientCell.self)
    }
    
    private func setupData() {
        self.alcoholicTitle.text = "DETAIL.ALCOHOLIC".localized
        self.alcoholicLabel.text = viewModel.drink.alcoholic.capitalized

        self.categoryTitle.text = "DETAIL.CATEGORY".localized
        self.categoryLabel.text = viewModel.drink.category.capitalized
        
        self.ingredientsTitle.text = "DETAIL.INGREDIENTS".localized
        self.glassTitle.text = "DETAIL.GLASS".localized
        self.glassLabel.text = viewModel.drink.glass.capitalized

        self.instructionsTitle.text = "DETAIL.INSTRUCTIONS".localized
        self.instructionsLabel.text = viewModel.instructionText
        
        if let data = viewModel.drink.imageData {
            drinkImageView.image = UIImage(data: data)
        } else {
            drinkImageView.image = UIImage(named: "placeholder")
        }
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.drink.ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: IngredientCell.self)
        cell.configure(with: viewModel.getIngredientViewModel(for: indexPath.row))
        return cell
    }
}
