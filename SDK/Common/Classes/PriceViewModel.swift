//
//  PriceViewModel.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation
import Domain
import Stylesheet

public struct PriceViewModel {
    public let attributedPrice: NSAttributedString?
    
    public init(price: Price, formatter: NumberFormatter, attributes: TextAttributes) {
        let formatter = formatter
        formatter.maximumFractionDigits = PriceViewModel.precision(for: price)
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            attributedPrice = NSAttributedString(
                string: formattedPrice,
                attributes: attributes
            )
        } else {
            attributedPrice = nil
        }
    }
}

private extension PriceViewModel {
    static func precision(for price: Double) -> Int {
        if price >= 1.0 {
            return 2
        } else if price < 0.0001 {
            return 7
        } else if price < 0.01 {
            return 5
        } else if price < 0.1 {
            return 4
        }
        
        return 3
    }
}
