//
//  AssetViewModel.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import UIKit
import Common
import Domain
import Stylesheet

struct AssetViewModel {
    let attributedSymbol: NSAttributedString
    let attributedName: NSAttributedString
    let priceViewModel: PriceViewModel
    
    init(asset: Asset, stylesheet: Stylesheet) {
        attributedSymbol = NSAttributedString(
            string: asset.symbol ?? "—",
            attributes: stylesheet.assetSymbolTextAttributes
        )
        
        attributedName = NSAttributedString(
            string: asset.name,
            attributes: stylesheet.assetNameAttributes
        )
        
        priceViewModel = PriceViewModel(
            price: asset.priceUsd,
            formatter: stylesheet.currencyFormatter,
            attributes: stylesheet.assetPriceAttributes
        )
    }
}
