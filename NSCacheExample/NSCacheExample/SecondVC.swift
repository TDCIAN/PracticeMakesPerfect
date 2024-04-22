//
//  SecondVC.swift
//  NSCacheExample
//
//  Created by 김정민 on 4/2/24.
//

import UIKit

class SecondVC: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalToConstant: 300),
            self.imageView.heightAnchor.constraint(equalToConstant: 300),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        ImageProvider.shared.fetchImage { [weak self] image in
            self?.imageView.image = image
        }
    }
    
}
