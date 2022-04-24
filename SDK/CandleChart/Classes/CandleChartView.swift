//
//  CandleChartView.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import UIKit
import Common
import Domain
import RxSwift
import Stylesheet

public final class CandleChartView: UIView {
    private let stylesheet: Stylesheet
    
    var candles: [Candle] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public init(frame: CGRect, stylesheet: Stylesheet) {
        self.stylesheet = stylesheet
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(rect)
        
        let margin: CGFloat = 8.0
        let width = rect.width - margin * 2
        let height = rect.height - margin * 2
            
        let candleX = { (index: Int) -> CGFloat in
            let spacing = width / CGFloat(self.candles.count - 1)
            return CGFloat(index) * spacing + margin
        }
        
        guard
            let minPrice = candles.map({ $0.low }).min(),
            let maxPrice = candles.map({ $0.high }).max()
        else {
            return
        }
        
        let candleY = { (price: Price) -> CGFloat in
            let yPoint = CGFloat(price - minPrice) / CGFloat(maxPrice - minPrice) * height
            return height - yPoint + margin
        }
        
        for (i, candle) in candles.enumerated() {
            if candle.close > candle.open {
                UIColor.green.setStroke()
            } else if candle.close < candle.open {
                UIColor.red.setStroke()
            } else {
                UIColor.gray.setStroke()
            }
            
            let xPoint = candleX(i)
            
            // draw candle's shadow
            
            let shadowPath = UIBezierPath()
            shadowPath.lineWidth = 1
            
            let lowPoint = CGPoint(x: xPoint, y: candleY(candle.low))
            shadowPath.move(to: lowPoint)
            
            let highPoint = CGPoint(x: xPoint, y: candleY(candle.high))
            shadowPath.addLine(to: highPoint)
            shadowPath.stroke()
            
            // draw candle's body
            
            let bodyPath = UIBezierPath()
            bodyPath.lineWidth = 5
            
            let openPoint = CGPoint(x: xPoint, y: candleY(candle.open))
            bodyPath.move(to: openPoint)
            
            let closePoint = CGPoint(
                x: xPoint,
                y: candleY(candle.close) == candleY(candle.open)
                    ? candleY(candle.open) + 1
                    : candleY(candle.close)
            )
            bodyPath.addLine(to: closePoint)
            bodyPath.stroke()
        }
        
        let minPriceVM = PriceViewModel(
            price: minPrice,
            formatter: stylesheet.currencyFormatter,
            attributes: stylesheet.chartLabelTextAttributes
        )
        
        if let attributedMinPrice = minPriceVM.attributedPrice {
            let size = attributedMinPrice.boundingRect(
                with: CGSize(width: width, height: height),
                options: [],
                context: nil
            ).size
            
            let point = CGPoint(
                x: width - size.width + margin,
                y: height
            )
            
            attributedMinPrice.draw(at: point)
        }
        
        let maxPriceVM = PriceViewModel(
            price: maxPrice,
            formatter: stylesheet.currencyFormatter,
            attributes: stylesheet.chartLabelTextAttributes
        )
        
        if let attributedMaxPrice = maxPriceVM.attributedPrice {
            let size = attributedMaxPrice.boundingRect(
                with: CGSize(width: width, height: height),
                options: [],
                context: nil
            ).size
            
            let point = CGPoint(
                x: width - size.width + margin,
                y: 0
            )
            
            attributedMaxPrice.draw(at: point)
        }
    }
}

extension Reactive where Base: CandleChartView {
    public var candles: Binder<[Candle]> {
        Binder(base) { view, candles in
            view.candles = candles
        }
    }
}
