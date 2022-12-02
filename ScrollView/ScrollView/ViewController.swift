//
//  ViewController.swift
//  ScrollView
//
//  Created by JeongminKim on 2022/12/02.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemGreen
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var firstView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        return view
    }()
    
    private lazy var thirdView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .systemBlue
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        [firstView, secondView, thirdView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }

    private func setLayout() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            firstView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            firstView.heightAnchor.constraint(equalToConstant: 700),
            
            secondView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            secondView.heightAnchor.constraint(equalToConstant: 700),
            
            thirdView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            thirdView.heightAnchor.constraint(equalToConstant: 700),
        ])

    }

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrolled")
    }
}
