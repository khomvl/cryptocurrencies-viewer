//
//  Candle.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation

public struct Candles: Decodable {
    public let values: [[Double]]
}

public struct Candle {
    public let timestamp: Date
    public let open: Price
    public let close: Price
    public let high: Price
    public let low: Price
    
    public init(timestamp: Date, open: Price, close: Price, high: Price, low: Price) {
        self.timestamp = timestamp
        self.open = open
        self.close = close
        self.high = high
        self.low = low
    }
}

extension Candle: CustomStringConvertible {
    public var description: String {
        """
        Candle {
            open: \(open),
            close: \(close),
            high: \(high),
            low: \(low)
        } @ \(timestamp)
        """
    }
}
