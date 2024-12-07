//
//  BannerCollectionViewCell.swift
//  BasicCompositionalLayout
//
//  Created by 김정민 on 10/29/24.
//

import UIKit
import SnapKit
import Kingfisher

class BannerCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = UILabel()
    private let backgroundImage: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.contentView.addSubview(self.backgroundImage)
        self.contentView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func config(title: String, imageUrl: String) {
        self.titleLabel.text = title
        self.backgroundImage.kf.setImage(with: URL(string: imageUrl))
    }
}
