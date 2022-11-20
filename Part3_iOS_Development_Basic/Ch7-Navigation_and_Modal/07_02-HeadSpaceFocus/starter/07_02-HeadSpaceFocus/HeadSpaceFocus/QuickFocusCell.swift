//
//  QuickFocusCell.swift
//  HeadSpaceFocus
//
//  Created by JeongminKim on 2022/11/20.
//

import UIKit

final class QuickFocusCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(_ quickFocus: QuickFocus) {
        thumbnailImageView.image = UIImage(named: quickFocus.imageName)
        titleLabel.text = quickFocus.title
        descriptionLabel.text = quickFocus.description
    }
}
