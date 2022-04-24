//
//  UICollectionView+Ext.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 13.04.2022.
//

import UIKit

public extension Ext where Base: UICollectionView {
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        base.register(name, forCellWithReuseIdentifier: name.ext.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = base.dequeueReusableCell(withReuseIdentifier: name.ext.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(name.ext.reuseIdentifier)")
        }
        return cell
    }
}
