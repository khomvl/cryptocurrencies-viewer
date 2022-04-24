//
//  AssetsListViewController.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 13.04.2022.
//

import UIKit
import AssetProfile
import Domain
import Extensions
import RxSwift
import Stylesheet

@frozen
enum AssetsSection {
    case main
}

typealias AssetsDataSource = UICollectionViewDiffableDataSource<AssetsSection, Asset>
typealias AssetsSnapshot = NSDiffableDataSourceSnapshot<AssetsSection, Asset>

public final class AssetsListViewController: UIViewController {

    private let viewModel: AssetsListViewModel
    private let stylesheet: Stylesheet
    
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.ext.register(cellWithClass: AssetCell.self)
        
        return collectionView
    }()
    
    private lazy var dataSource = AssetsDataSource(collectionView: collectionView) { [unowned self]
        (collectionView, indexPath, asset) -> UICollectionViewCell? in
        
        let cell = collectionView.ext.dequeueReusableCell(withClass: AssetCell.self, for: indexPath)
        let viewModel = AssetViewModel(asset: asset, stylesheet: self.stylesheet)
        cell.fillIn(with: viewModel)
        
        return cell
    }
    
    public init(viewModel: AssetsListViewModel, stylesheet: Stylesheet) {
        self.viewModel = viewModel
        self.stylesheet = stylesheet
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.loadNextIfPossible()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor =  .white
        
        collectionView.delegate = self
        
        configureUI()
        configureSubscriptions()
    }

    public override var shouldAutorotate: Bool {
        false
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .portrait
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        [.portrait]
    }
}

private extension AssetsListViewController {
    func configureUI() {
        title = "Cryptocurrencies"
        
        view.addSubview(collectionView)
        
        let layout = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    func configureSubscriptions() {
        subscribeOnViewModel()
        subscribeOnScrolling()
        subscribeOnCellTaps()
    }
    
    func subscribeOnViewModel() {
        viewModel.assets.asObservable()
            .map { assets -> AssetsSnapshot in
                var snapshot = AssetsSnapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(assets, toSection: .main)

                return snapshot
            }
            .observe(on: MainScheduler.instance)
            .subscribe { [unowned self] snapshot in
                self.dataSource.apply(snapshot)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func subscribeOnScrolling() {
        Observable.combineLatest(
            collectionView.rx.contentOffset.asObservable(),
            collectionView.rx.observe(\.contentSize)
        )
            .observe(on: MainScheduler.instance)
            .map { [unowned self] offset, size -> Bool in
                let boundsHeight = self.collectionView.bounds.height
                return offset.y > size.height - boundsHeight * 2
            }
            .compactMap { $0 ? () : nil }
            .subscribe(onNext: { [unowned self] in
                self.viewModel.loadNextIfPossible()
            })
            .disposed(by: disposeBag)
    }
    
    func subscribeOnCellTaps() {
        collectionView.rx.itemSelected
            .compactMap { [unowned self] indexPath in
                self.dataSource.itemIdentifier(for: indexPath)
            }
            .subscribe(onNext: { [unowned self] asset in
                // TODO: вынести в координатор
                let viewModel = AssetProfileViewModel(
                    asset: asset,
                    api: self.viewModel.api,
                    stylesheet: stylesheet
                )
                let viewController = AssetProfileViewController(
                    viewModel: viewModel,
                    stylesheet: stylesheet
                )
                
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension AssetsListViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: view.bounds.width,
            height: stylesheet.cellHeight
        )
    }
}
