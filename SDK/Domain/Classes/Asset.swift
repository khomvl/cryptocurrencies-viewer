//
//  Asset.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 13.04.2022.
//

import Foundation

public typealias AssetId = String
public typealias Price = Double

public struct Asset {
    public let id: AssetId
    public let symbol: String?
    public let name: String
    public let priceUsd: Price
    
    @frozen
    enum Keys: String, CodingKey {
        case id
        case symbol
        case name
        case metrics
        
        @frozen
        enum Metrics: String, CodingKey {
            case marketData
            
            @frozen
            enum MarketData: String, CodingKey {
                case priceUsd
            }
        }
    }
}

extension Asset: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(AssetId.self, forKey: .id)
        symbol = try container.decode(String?.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        
        let metricsContainer = try container.nestedContainer(
            keyedBy: Keys.Metrics.self,
            forKey: .metrics
        )
        
        let marketDataContainer = try metricsContainer.nestedContainer(
            keyedBy: Keys.Metrics.MarketData.self,
            forKey: .marketData
        )
        
        priceUsd = try marketDataContainer.decode(Price.self, forKey: .priceUsd)
    }
}

extension Asset: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Asset, rhs: Asset) -> Bool {
        lhs.id == rhs.id
    }
}

extension Asset: CustomStringConvertible {
    public var description: String {
        """
        Asset {
            id: \(id),
            symbol: \(symbol ?? "(null)"),
            name: \(name),
            price: $\(String(format: "%.2f", priceUsd))
        }
        """
    }
}
