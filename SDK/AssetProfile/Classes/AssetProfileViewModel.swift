//
//  AssetProfileViewModel.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation
import Common
import Domain
import MessariAPI
import RxSwift
import Stylesheet

public final class AssetProfileViewModel {
    private let asset: Asset
    private let api: MessariAPI
    private let stylesheet: Stylesheet
    
    private var profile: Observable<AssetProfile> {
        api.getAssetProfile(assetId: asset.id).share()
    }
    
    var title: Observable<String> {
        Observable.just(asset)
            .map {
                guard let symbol = $0.symbol else {
                    return $0.name
                }
                
                return "\($0.name) (\(symbol))"
            }
    }
    
    var priceViewModel: Observable<PriceViewModel> {
        Observable.just((asset.priceUsd, stylesheet))
            .map {
                PriceViewModel(
                    price: $0,
                    formatter: $1.currencyFormatter,
                    attributes: $1.assetProfilePriceAttributes
                )
            }
    }
    
    var candles: Observable<[Candle]> {
        api.getTimeSeries(forAssetWith: asset.id)
    }
    
    var attributedTagline: Observable<NSAttributedString> {
        Observable.combineLatest(
            profile.compactMap { $0.tagline },
            Observable.just(stylesheet)
        )
            .map { tagline, stylesheet in
                NSAttributedString(
                    string: tagline,
                    attributes: stylesheet.assetProfileTaglineAttributes
                )
            }
    }
    
    var attributedProjectDetails: Observable<NSAttributedString?> {
        profile.compactMap { profile -> NSAttributedString? in
            let modifiedFont = String(
                format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: 12pt\">%@</span>",
                profile.projectDetails
            )
            
            guard let data = modifiedFont.data(using: .utf8) else {
                return nil
            }
            
            return try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                ],
                documentAttributes: nil
            )
        }
    }
    
    var links: Observable<[OfficialLink]> {
        profile.map { $0.officialLinks }
    }
    
    public init(asset: Asset, api: MessariAPI, stylesheet: Stylesheet) {
        self.asset = asset
        
        self.api = api
        self.stylesheet = stylesheet
    }
}
