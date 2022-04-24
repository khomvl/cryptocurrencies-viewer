//
//  AssetProfileViewController.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import UIKit
import Domain
import Extensions
import RxSwift
import RxCocoa
import SafariServices
import Stylesheet

@frozen
enum LinksSection {
    case main
}

typealias LinksSnapshot = NSDiffableDataSourceSnapshot<LinksSection, OfficialLink>
typealias LinksDataSource = UICollectionViewDiffableDataSource<LinksSection, OfficialLink>

public final class AssetProfileViewController: UIViewController {
    private let viewModel: AssetProfileViewModel
    private let stylesheet: Stylesheet
    
    private let disposeBag = DisposeBag()
    
    private var assetProfileView: AssetProfileView {
        view as! AssetProfileView
    }
    
    private var linksCollectionView: UICollectionView {
        assetProfileView.linksCollectionView
    }
    
    private lazy var linksDataSource = LinksDataSource(collectionView: linksCollectionView) { collectionView, indexPath, link in
        let linkCell = collectionView.ext.dequeueReusableCell(withClass: OfficialLinkCell.self, for: indexPath)
        
        linkCell.set(image: link.linkType?.image)
        
        return linkCell
    }
    
    public init(viewModel: AssetProfileViewModel, stylesheet: Stylesheet) {
        self.viewModel = viewModel
        self.stylesheet = stylesheet
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = AssetProfileView(frame: .zero, stylesheet: stylesheet)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubscriptions()
    }
}

private extension AssetProfileViewController {
    func configureSubscriptions() {
        viewModel.title
            .asDriver(onErrorJustReturn: "") // ???
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        viewModel.priceViewModel
            .compactMap { $0.attributedPrice }
            .asDriver(onErrorJustReturn: NSAttributedString())
            .drive(assetProfileView.rx.price)
            .disposed(by: disposeBag)
        
        viewModel.candles
            .asDriver(onErrorJustReturn: [])
            .drive(assetProfileView.chartView.rx.candles)
            .disposed(by: disposeBag)
        
        viewModel.attributedTagline
            .asDriver(onErrorJustReturn: NSAttributedString())
            .drive(assetProfileView.rx.tagline)
            .disposed(by: disposeBag)
        
        viewModel.attributedProjectDetails
            .asDriver(onErrorJustReturn: NSAttributedString())
            .drive(assetProfileView.rx.projectDetails)
            .disposed(by: disposeBag)
        
        viewModel.links
            .compactMap {
                $0.compactMap { link in
                    link.linkType != nil ? link : nil
                }
            }
            .map { links -> LinksSnapshot in
                var snapshot = LinksSnapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(links, toSection: .main)
                
                return snapshot
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] snapshot in
                self.linksDataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        linksCollectionView.rx.itemSelected
            .compactMap { [unowned self] indexPath -> OfficialLink? in
                return self.linksDataSource.itemIdentifier(for: indexPath)
            }
            .subscribe(onNext: { [unowned self] link in
                // TODO: move to coordinator
                let vc = SFSafariViewController(url: link.url)
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
