//
//  DefaultStylesheet.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import UIKit

public final class DefaultStylesheet: Stylesheet {
    public let assetSymbolTextAttributes: TextAttributes = [
        .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
        .foregroundColor: UIColor.black
    ]
    
    public let assetNameAttributes: TextAttributes = [
        .font: UIFont.systemFont(ofSize: 12),
        .foregroundColor: UIColor.gray
    ]
    
    public let assetPriceAttributes: TextAttributes = [
        .foregroundColor: UIColor.black
    ]
    
    public let cellHeight: CGFloat = 60.0
    
    public var assetProfilePriceAttributes: TextAttributes = [
        .font: UIFont.boldSystemFont(ofSize: 32)
    ]
    
    public var assetProfileTaglineAttributes: TextAttributes = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.gray
    ]
    
    public var chartLabelTextAttributes: TextAttributes = [
        .font: UIFont.systemFont(ofSize: 10),
        .foregroundColor: UIColor.gray
    ]
    
    public let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter
    }()
    
    public init() { }
}
