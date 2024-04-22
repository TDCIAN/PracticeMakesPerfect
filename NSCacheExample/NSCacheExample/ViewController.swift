//
//  ViewController.swift
//  NSCacheExample
//
//  Created by 김정민 on 4/2/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        let button = UIButton()
        button.setTitle("Tap Me", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc private func didTapButton() {
        let vc = SecondVC()
        self.present(vc, animated: true)
    }

}

