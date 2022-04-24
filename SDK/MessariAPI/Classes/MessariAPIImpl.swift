//
//  MessariAPIImpl.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation
import Domain
import RxSwift

public final class MessariAPIImpl: MessariAPI {
    
    @frozen
    private enum Constants {
        static let messariHost = "data.messari.io"
        static let getAssetsFields = "id,symbol,name,metrics/market_data/price_usd"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        static let getAssetProfileFields = "profile/general/overview"
        static let getTimeSeriesFields = "values"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            return formatter
        }()
    }
    
    private let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // https://data.messari.io/api/v2/assets?fields=id,symbol,name,metrics/market_data/price_usd&page=1
    public func getAssets(page: Int) -> Observable<[Asset]> {
        // TODO: вынести в Request, избавиться от дублирования?
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.messariHost
        urlComponents.path = "/api/v2/assets"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "fields", value: Constants.getAssetsFields)
        ]

        guard let url = urlComponents.url else {
            return .error(MessariAPIError.incorrectUrl)
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-messari-api-key")
        
        return URLSession.shared.rx.data(request: request)
            .debug("r")
            .map { data -> MessariAPIResponse<[Asset]> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                return try decoder.decode(MessariAPIResponse<[Asset]>.self, from: data)
            }
            .compactMap { $0.data }
    }
    
    // https://data.messari.io/api/v2/assets/1e31218a-e44e-4285-820c-8282ee222035/profile?&fields=profile/general/overview
    public func getAssetProfile(assetId: AssetId) -> Observable<AssetProfile> {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.messariHost
        urlComponents.path = "/api/v2/assets/\(assetId)/profile"
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: Constants.getAssetProfileFields)
        ]
        
        guard let url = urlComponents.url else {
            return .error(MessariAPIError.incorrectUrl)
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-messari-api-key")
        
        return URLSession.shared.rx.data(request: request)
            .debug("r")
            .map { data -> MessariAPIResponse<AssetProfile> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                return try decoder.decode(MessariAPIResponse<AssetProfile>.self, from: data)
            }
            .compactMap { $0.data }
    }
    
    // https://data.messari.io/api/v1/assets/1e31218a-e44e-4285-820c-8282ee222035/metrics/price/time-series?start=2022-03-14&end=2022-04-14&columns=open,close,high,low&interval=1d&fields=values
    public func getTimeSeries(forAssetWith id: AssetId) -> Observable<[Candle]> {
        let endDate = Date()
        guard let startDate = Calendar.autoupdatingCurrent
            .date(byAdding: .month, value: -1, to: endDate) else {
                return .error(MessariAPIError.invalidDate)
            }
        
        let formatter = Constants.dateFormatter
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.messariHost
        urlComponents.path = "/api/v1/assets/\(id)/metrics/price/time-series"
        urlComponents.queryItems = [
            URLQueryItem(name: "start", value: formatter.string(from: startDate)),
            URLQueryItem(name: "end", value: formatter.string(from: endDate)),
            URLQueryItem(name: "columns", value: "open,close,high,low"),
            URLQueryItem(name: "interval", value: "1d"),
            URLQueryItem(name: "fields", value: Constants.getTimeSeriesFields)
        ]
        
        guard let url = urlComponents.url else {
            return .error(MessariAPIError.incorrectUrl)
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-messari-api-key")
        
        return URLSession.shared.rx.data(request: request)
            .debug("r")
            .map { data -> MessariAPIResponse<Candles> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                return try decoder.decode(MessariAPIResponse<Candles>.self, from: data)
            }
            .map { response -> [Candle] in
                let doubles = response.data?.values ?? []
                
                return doubles.map {
                    Candle(
                        timestamp: Date(timeIntervalSince1970: $0[0]),
                        open: $0[1],
                        close: $0[2],
                        high: $0[3],
                        low: $0[4]
                    )
                }
            }
    }
}
