//
//  FooterView.swift
//  compositional_layout
//
//  Created by JeongminKim on 2023/05/30.
//

import UIKit
import SnapKit

class FooterView: UICollectionReusableView {
    static let identifier = "FooterView"
    
    private let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        activityIndicator.hidesWhenStopped = true
    }
    
    func toggleLoading(isEnabled: Bool) {
        if isEnabled {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
