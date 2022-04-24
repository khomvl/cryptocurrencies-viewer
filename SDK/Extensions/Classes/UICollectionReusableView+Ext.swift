//
//  UICollectionReusableView+Ext.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 13.04.2022.
//

import UIKit

public extension Ext where Base: UICollectionReusableView {
    static var reuseIdentifier: String {
        return NSStringFromClass(Base.self)
    }
}
