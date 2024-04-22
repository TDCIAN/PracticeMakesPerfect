//
//  ViewController.swift
//  CombineMVVM
//
//  Created by 김정민 on 4/22/24.
//

import UIKit
import Combine

class QuoteViewModel {
    
}

class QuoteViewController: UIViewController {
    
    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 1
        label.textColor = .label
        label.text = "Label Label Label Label Label Label Label Label"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.backgroundColor = .systemBlue
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.refreshButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.borderColor = UIColor.blue.cgColor
        stackView.layer.borderWidth = 1
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }

    private func setup() {
        [self.quoteLabel, self.refreshButton].forEach {
            self.stackView.addArrangedSubview($0)
        }
        
        self.view.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.stackView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            self.refreshButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc private func refreshButtonTapped() {
        
    }
}

protocol QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error>
}

class QuoteService: QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, any Error> {
        guard let url = URL(string: "https://api.quotable.io/random") else {
            return Empty().eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { (error: URLError) in
                return Fail(error: error).eraseToAnyPublisher()
            }.map({ $0.data })
            .decode(type: Quote.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct Quote: Decodable {
    let content: String
    let author: String
}
