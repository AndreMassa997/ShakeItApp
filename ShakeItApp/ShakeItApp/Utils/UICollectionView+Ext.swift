//
//  UICollectionView+Ext.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 18/05/24.
//

import UIKit

extension UICollectionView {
    // MARK: - Cells
    final func register<T: UICollectionViewCell>(cellType: T.Type) where T: CellReusable {
        self.register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: CellReusable {
        let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
        guard let typedCell = cell as? T else {
            preconditionFailure("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType). Check that the reuseIdentifier is set properly and that you registered the cell for reuse.")
        }
        return typedCell
    }
}
