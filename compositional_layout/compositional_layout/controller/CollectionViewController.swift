//
//  ViewController.swift
//  compositional_layout
//
//  Created by JeongminKim on 2023/05/30.
//

import UIKit
import Combine
import SnapKit
import SDWebImage

class CollectionViewController: UICollectionViewController {
    
    enum Section: Int, CaseIterable {
        case grid
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    private var layout: UICollectionViewCompositionalLayout!
    
    @Published private var products: [Product] = []
    private var cancellables = Set<AnyCancellable>()
    private var isPaginating = false

    override func loadView() {
        super.loadView()
        observe()
        setupNavigation()
        setupDataSource()
        setupCompositionalLayout()
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
    }

    private func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Products"
    }

    private func setupCollectionView() {
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cellId"
        )
        collectionView.register(
            ProductCell.self,
            forCellWithReuseIdentifier: ProductCell.identifier
        )
        collectionView.register(
            FooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterView.identifier
        )
        collectionView.collectionViewLayout = layout
    }
    
    private func setupDataSource() {
        dataSource = .init(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let section = Section(rawValue: indexPath.section) else {
                    return UICollectionViewCell()
                }
                switch section {
                case .grid:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ProductCell.identifier,
                        for: indexPath
                    ) as! ProductCell
                    cell.configure(item: itemIdentifier)
                    return cell
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            guard let footerView = self.collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: FooterView.identifier,
                for: indexPath
            ) as? FooterView else {
                fatalError()
            }
            footerView.toggleLoading(isEnabled: isPaginating)
            return footerView
        }
    }
    
    private func setupCompositionalLayout() {
        layout = .init(sectionProvider: { sectionIndex, environment in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .grid:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(0.5),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(0.3)
                    ),
                    subitems: [item]
                )
                group.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
                let section = NSCollectionLayoutSection(group: group)
                let footerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(44)
                )
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom
                )
                section.boundarySupplementaryItems = [footer]
                return section
            }
        })
    }
    
    private func observe() {
        $products
            .filter { !$0.isEmpty }
            .receive(on: RunLoop.main)
            .sink { [weak self] products in
                self?.reloadSnapshot()
            }.store(in: &cancellables)
    }
    
    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.grid])
        snapshot.appendItems(products, toSection: .grid)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func fetchProducts(completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [unowned self] in
            let currentCount = products.count
            var newItems = [Product]()
            for i in 1..<11 {
                let newCount = currentCount + i
                let item = Product(
                    name: "Product \(newCount)",
                    imageURL: "https://source.unsplash.com/random/?product&\(newCount)")
                newItems.append(item)
            }
            products.append(contentsOf: newItems)
            completion?()
        })
    }
}

extension CollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == products.count - 1 {
            print("last reached, paginate now")
            isPaginating = true
            fetchProducts { [weak self] in
                self?.isPaginating = false
            }
        }
    }
}
