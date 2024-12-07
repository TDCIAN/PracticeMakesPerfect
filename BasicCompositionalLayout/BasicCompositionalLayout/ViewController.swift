//
//  ViewController.swift
//  BasicCompositionalLayout
//
//  Created by 김정민 on 10/25/24.
//

import UIKit

class ViewController: UIViewController {
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        
        self.collectionView.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.className
        )
        self.collectionView.setCollectionViewLayout(
            self.createLayout(),
            animated: true
        )
        self.setDataSource()
        self.setSnapShot()
    }
    
    private func setUI() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([Section(id: "Banner")])
        let bannerItems = [
            Item.banner(
                HomeItem(
                    title: "교촌 치킨",
                    imageUrl: "https://image.ytn.co.kr/general/jpg/2021/1118/202111181530016782_d.jpg"
                )
            ),
            Item.banner(
                HomeItem(
                    title: "굽네 치킨",
                    imageUrl: "https://www.thinkfood.co.kr/news/photo/202203/93989_122423_5341.jpg"
                )
            ),
            Item.banner(
                HomeItem(
                    title: "푸라닥 치킨",
                    imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5wjaoN_ORZ1v4ruVgAhTXlRY2hDytQEAliA&s"
                )
            )
        ]
        snapshot.appendItems(bannerItems, toSection: Section(id: "Banner"))
        
        self.dataSource?.apply(snapshot)
    }
    
    private func setDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .banner(let item):
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BannerCollectionViewCell.className,
                    for: indexPath
                ) as? BannerCollectionViewCell else { return UICollectionViewCell() }
                
                cell.config(title: item.title, imageUrl: item.imageUrl)
                
                return cell
                
            case .normalCarousel(let item):
                return UICollectionViewCell()
            case .listCarousel(_):
                return UICollectionViewCell()
            }
        }
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            switch sectionIndex {
            case 1:
                return self?.createBannerSection()
            default:
                return self?.createBannerSection()
            }
        })
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}




// 컬렉션뷰 cell UI - 등록
// 레이아웃 구현 - 3가지
// datasource -> cellProvider
// snapshot -> datasource.apply(snapshot)

extension UIView {
    static var className: String {
        String(describing: type(of: self))
    }
}
