//
//  AssetProfileView.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import UIKit
import CandleChart
import Extensions
import RxSwift
import Stylesheet

final class AssetProfileView: UIView {
    private enum Constants {
        static let footerHeight: CGFloat = 52
        static let linkCellSize = CGSize(width: 36, height: 36)
    }
    
    private let stylesheet: Stylesheet
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let priceLabel = UILabel()
    lazy var chartView = CandleChartView(frame: .zero, stylesheet: stylesheet)
    
    let taglineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    let projectDetails: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private let footerView = UIView()
    
    lazy var linksCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.ext.register(cellWithClass: OfficialLinkCell.self)
        
        return collectionView
    }()
    
    init(frame: CGRect, stylesheet: Stylesheet) {
        self.stylesheet = stylesheet
        
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = .white
        createViewHierarchy()
        configureLayout()
    }
    
    func createViewHierarchy() {
        [scrollView, contentView, priceLabel, chartView, footerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [scrollView, footerView].forEach {
            addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [priceLabel, chartView, taglineLabel, projectDetails].forEach {
            contentView.addSubview($0)
        }
        
        footerView.addSubview(linksCollectionView)
    }
    
    func configureLayout() {
        let layout = [
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            {
                let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
                heightConstraint.priority = .defaultLow
                
                return heightConstraint
            }(),
            
            priceLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            chartView.topAnchor.constraint(equalToSystemSpacingBelow: priceLabel.bottomAnchor, multiplier: 1),
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chartView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor, multiplier: 3 / 4),
            
            taglineLabel.topAnchor.constraint(equalToSystemSpacingBelow: chartView.bottomAnchor, multiplier: 1),
            taglineLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            taglineLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            projectDetails.topAnchor.constraint(equalToSystemSpacingBelow: taglineLabel.bottomAnchor, multiplier: 1),
            projectDetails.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            projectDetails.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            projectDetails.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            footerView.bottomAnchor.constraint(
                equalToSystemSpacingBelow: safeAreaLayoutGuide.bottomAnchor,
                multiplier: 1
            ),
            footerView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Constants.footerHeight),
            
            linksCollectionView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            linksCollectionView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            linksCollectionView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            linksCollectionView.heightAnchor.constraint(equalToConstant: Constants.linkCellSize.height),
        ]
        
        NSLayoutConstraint.activate(layout)
    }
}

extension AssetProfileView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        Constants.linkCellSize
    }
}

extension Reactive where Base: AssetProfileView {
    var price: Binder<NSAttributedString> {
        Binder(base) { view, attributedPrice in
            view.priceLabel.attributedText = attributedPrice
        }
    }
    
    var tagline: Binder<NSAttributedString?> {
        Binder(base) { view, attributedTagline in
            view.taglineLabel.attributedText = attributedTagline
        }
    }
    
    var projectDetails: Binder<NSAttributedString?> {
        Binder(base) { view, attributedDetails in
            view.projectDetails.attributedText = attributedDetails
        }
    }
}
