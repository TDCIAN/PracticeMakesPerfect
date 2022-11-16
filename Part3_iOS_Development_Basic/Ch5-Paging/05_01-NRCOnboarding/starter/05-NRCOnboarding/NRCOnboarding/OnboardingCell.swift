//
//  OnboardingCell.swift
//  NRCOnboarding
//
//  Created by JeongminKim on 2022/11/16.
//

import UIKit

final class OnboardingCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(_ message: OnboardingMessage) {
        thumbnailImageView.image = UIImage(named: message.imageName)
        titleLabel.text = message.title
        descriptionLabel.text = message.description
    }
}
