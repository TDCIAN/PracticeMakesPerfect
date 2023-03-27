//
//  ViewController.swift
//  PictureInPicture
//
//  Created by JeongminKim on 2023/03/27.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("PLAY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        [playerView, button].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16.0),
            playerView.heightAnchor.constraint(equalToConstant: 200),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 100),
        ])
    }


}

