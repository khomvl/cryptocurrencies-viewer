//
//  Stylesheet.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation
import UIKit

public typealias TextAttributes = [NSAttributedString.Key : Any]

public protocol Stylesheet {
    // List
    
    var assetSymbolTextAttributes: TextAttributes { get }
    var assetNameAttributes: TextAttributes { get }
    var assetPriceAttributes: TextAttributes { get }
    var cellHeight: CGFloat { get }
    
    // Profile
    
    var assetProfilePriceAttributes: TextAttributes { get }
    var assetProfileTaglineAttributes: TextAttributes { get }
    
    // Chart
    
    var chartLabelTextAttributes: TextAttributes { get }
    
    // Common
    
    var currencyFormatter: NumberFormatter { get }
}
