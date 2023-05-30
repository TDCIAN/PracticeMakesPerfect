//
//  ProductCell.swift
//  compositional_layout
//
//  Created by JeongminKim on 2023/05/30.
//

import UIKit
import SnapKit
import SDWebImage

final class ProductCell: UICollectionViewCell {
    static let identifier = "GridCell"
    
    private let placeholderImage = UIImage(systemName: "photo.fill")?
        .withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = placeholderImage
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.layer.borderColor = UIColor.systemBackground.cgColor
        contentView.layer.borderWidth = 1
        
        [label, productImageView].forEach {
            contentView.addSubview($0)
        }
        
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        label.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(productImageView.snp.bottom)
        }
    }
    
    func configure(item: Product) {
        label.text = item.name
        productImageView.sd_setImage(
            with: URL(string: item.imageURL),
            placeholderImage: placeholderImage
        )
    }
    
}
