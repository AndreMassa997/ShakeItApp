//
//  IngredientsCell.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 22/05/24.
//

import UIKit

final class IngredientsCell: UITableViewCell, CellReusable {
    var viewModel: IngredientsViewModel!
    
    private let collectionView: UICollectionView = {
        let layout = LeftAlignmentCollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        cv.contentInsetAdjustmentBehavior = .always
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.autoresizingMask = .flexibleHeight
        self.contentView.addSubview(collectionView)
        setupLayout()
        setupCollectionView()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: IngredientCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: IngredientsViewModel) {
        self.viewModel = viewModel
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        collectionView.frame = CGRect(x: collectionView.frame.origin.x, y: collectionView.frame.origin.y, width: collectionView.frame.width, height: 100)
        
        collectionView.layoutIfNeeded()
        
        let newCellSize = CGSize(width: collectionView.collectionViewLayout.collectionViewContentSize.width, height: collectionView.collectionViewLayout.collectionViewContentSize.height)
        
        return newCellSize
    }
}

extension IngredientsCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.ingredients.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: IngredientCell.self)
        cell.configure(with: viewModel.getIngredientViewModel(for: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ingredientNameWidth = (viewModel.getIngredientName(for: indexPath.row) as NSString).size(withAttributes: [.font: IngredientCell.ingredientFont]).width
        let measureNameWidth = (viewModel.getMeasureName(for: indexPath.row) as NSString).size(withAttributes: [.font: IngredientCell.measureFont]).width
        return CGSize(width: max(ingredientNameWidth, measureNameWidth) + IngredientCell.marginLeft + IngredientCell.marginRight + 10, height: 50)
    }
}

fileprivate class LeftAlignmentCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private let cellSpacing: CGFloat = 10
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = cellSpacing
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}

