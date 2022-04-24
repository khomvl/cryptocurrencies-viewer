//
//  ExtensionsProvider.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 13.04.2022.
//

import Foundation

public struct Ext<Base> {
    public var base: Base
    
    fileprivate init(with base: Base) {
        self.base = base
    }
}

public protocol ExtensionsProvider { }

public extension ExtensionsProvider {
    var ext: Ext<Self> {
        return Ext(with: self)
    }
    
    static var ext: Ext<Self>.Type {
        return Ext<Self>.self
    }
}

extension NSObject: ExtensionsProvider {}
