//
//  ViewController.swift
//  leftLeading
//
//  Created by JeongminKim on 2023/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello hello!"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(helloLabel)
        NSLayoutConstraint.activate([
            helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            helloLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }


}

