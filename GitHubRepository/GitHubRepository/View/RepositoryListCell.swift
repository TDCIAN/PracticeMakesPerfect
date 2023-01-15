//
//  RepositoryListCell.swift
//  GitHubRepository
//
//  Created by JeongminKim on 2022/11/29.
//

import UIKit
import SnapKit

final class RepositoryListCell: UITableViewCell {
    var repository: String?
    
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let starImageView = UIImageView()
    let starLabel = UILabel()
    let languageLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        [
            nameLabel, descriptionLabel,
            starImageView, starLabel, languageLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
}
