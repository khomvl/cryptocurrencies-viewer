//
//  CandleChartViewModel.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation
import Domain
import MessariAPI
import RxSwift

final class CandleChartViewModel {
    private let assetId: AssetId
    private let api: MessariAPI
    
    var candles: Observable<[Candle]> {
        api.getTimeSeries(forAssetWith: assetId)
    }
    
    init(assetId: AssetId, api: MessariAPI) {
        self.assetId = assetId
        self.api = api
    }
}
