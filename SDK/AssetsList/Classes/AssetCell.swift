//
//  AssetCell.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 13.04.2022.
//

import UIKit

final class AssetCell: UICollectionViewCell {
    private let symbolLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillIn(with viewModel: AssetViewModel) {
        symbolLabel.attributedText = viewModel.attributedSymbol
        nameLabel.attributedText = viewModel.attributedName
        priceLabel.attributedText = viewModel.priceViewModel.attributedPrice
    }
}

private extension AssetCell {
    func configureLayout() {
        [symbolLabel, nameLabel, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        let layout = [
            symbolLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            symbolLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.4),
            
            nameLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.6),
            
            priceLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.4)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
}
