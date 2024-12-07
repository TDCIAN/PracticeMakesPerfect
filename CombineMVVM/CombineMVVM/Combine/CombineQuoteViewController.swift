//
//  CombineQuoteViewController.swift
//  CombineMVVM
//
//  Created by 김정민 on 4/22/24.
//

import UIKit
import Combine

class CombineQuoteViewModel {
    
    enum Input {
        case viewDidAppear
        case refreshButtonDidTap
    }
    
    enum Output {
        case fetchQuoteDidFail(error: Error)
        case fetchQuoteDidSucceed(quote: Quote)
        case toggleButton(isEnabled: Bool)
    }

    private let quoteServiceType: CombineQuoteService
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    init(quoteServiceType: CombineQuoteService = CombineQuoteService()) {
        self.quoteServiceType = quoteServiceType
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] (event: Input) in
            switch event {
            case .viewDidAppear, .refreshButtonDidTap:
                self?.handleGetRandomQuote()
            }
        }
        .store(in: &self.cancellable)
        
        return self.output.eraseToAnyPublisher()
    }
    
    private func handleGetRandomQuote() {
        self.output.send(.toggleButton(isEnabled: false))
        self.quoteServiceType.getRandomQuote()
            .sink { [weak self] (completion: Subscribers.Completion<any Error>) in
                self?.output.send(.toggleButton(isEnabled: true))
                if case .failure(let failure) = completion {
                    self?.output.send(.fetchQuoteDidFail(error: failure))
                }
            } receiveValue: { [weak self] (quote: Quote) in
                self?.output.send(.fetchQuoteDidSucceed(quote: quote))
            }
            .store(in: &self.cancellable)
    }
}

class CombineQuoteViewController: UIViewController {
    
    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.text = "Please give me a random quote."
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.refreshButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let viewModel = CombineQuoteViewModel()
    private let input: PassthroughSubject<CombineQuoteViewModel.Input, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.input.send(.viewDidAppear)
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
            self.stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            self.refreshButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func bind() {
        let output = self.viewModel.transform(input: self.input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (event: CombineQuoteViewModel.Output) in
            switch event {
            case .fetchQuoteDidSucceed(let quote):
                self?.quoteLabel.text = quote.content
            case .fetchQuoteDidFail(let error):
                self?.quoteLabel.text = error.localizedDescription
            case .toggleButton(let isEnabled):
                self?.refreshButton.isEnabled = isEnabled
            }
        }
        .store(in: &self.cancellable)
    }
    
    @objc private func refreshButtonTapped() {
        self.input.send(.refreshButtonDidTap)
    }
}

protocol CombineQuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error>
}

class CombineQuoteService: CombineQuoteServiceType {
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
