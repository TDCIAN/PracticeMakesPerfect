//
//  QuickFocusHeaderView.swift
//  HeadSpaceFocus
//
//  Created by JeongminKim on 2022/11/20.
//

import UIKit

final class QuickFocusHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(_ title: String) {
        titleLabel.text = title
    }
}
