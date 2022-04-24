//
//  AssetsListViewModel.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation
import Domain
import MessariAPI
import RxSwift
import RxRelay

public final class AssetsListViewModel {
    let api: MessariAPI
    
    private var nextPage = 1
    
    let loading = BehaviorRelay<Bool>(value: false)
    let assets = BehaviorRelay<[Asset]>(value: [])
    
    public init(api: MessariAPI) {
        self.api = api
    }
    
    func loadNextIfPossible() {
        guard !loading.value else { return }
        
        loading.accept(true)
        
        _ = api.getAssets(page: nextPage)
            .scan(assets.value, accumulator: { $0 + $1 })
            .subscribe { [unowned self] assets in
                self.assets.accept(assets)
            } onCompleted: { [unowned self] in
                self.nextPage += 1
                self.loading.accept(false)
            }
    }
}
