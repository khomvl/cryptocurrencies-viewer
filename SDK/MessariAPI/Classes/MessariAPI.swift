//
//  MessariAPI.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 13.04.2022.
//

import Foundation

import Domain
import RxSwift
import RxCocoa

@frozen
public enum MessariAPIError: Error {
    case incorrectUrl
    case missingResource
    case invalidDate
}

public protocol MessariAPI {
    func getAssets(page: Int) -> Observable<[Asset]>
    func getAssetProfile(assetId: AssetId) -> Observable<AssetProfile>
    func getTimeSeries(forAssetWith id: AssetId) -> Observable<[Candle]>
}
