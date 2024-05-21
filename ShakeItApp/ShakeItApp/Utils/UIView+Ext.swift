//
//  UIView+Ext.swift
//  ShakeItApp
//
//  Created by Andrea Massari on 19/05/24.
//

import UIKit

extension UIView {
    @discardableResult
    func loadFromNib<T : UIView>() -> T? {
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(String(describing: type(of: self)) , owner: self, options: nil)?[0] as? T else {
            return nil
        }
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        return view
    }
}
