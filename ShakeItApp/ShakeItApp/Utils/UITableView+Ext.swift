//
//  UITableView+Ext.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit

extension UITableView {
    
    // MARK: - Cells
    final func register<T: UITableViewCell>(cellType: T.Type) where T: CellReusable {
        self.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: CellReusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            preconditionFailure("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType). Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell for reuse.")
        }
        return cell
    }
}
