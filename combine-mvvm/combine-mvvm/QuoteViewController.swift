//
//  ViewController.swift
//  combine-mvvm
//
//  Created by JeongminKim on 2023/05/25.
//

import UIKit
import Combine

class QuoteViewModel {
    
    enum Input {
        case viewDidAppear
        case refreshButtonDidTap
    }
    
    enum Output {
        case fetchQuoteDidFail(error: Error)
        case fetchQuoteDidSucceed(quote: Quote)
        case toggleButton(isEnabled: Bool)
    }
    
    private let quoteServiceType: QuoteServiceType
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(quoteServiceType: QuoteServiceType = QuoteService()) {
        self.quoteServiceType = quoteServiceType
    }
    
    func transform(input: AnyPublisher<Input,Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear, .refreshButtonDidTap:
                self?.handleGetRandomeQuote()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleGetRandomeQuote() {
        output.send(.toggleButton(isEnabled: false))
        quoteServiceType.getRandomQuote().sink { [weak self] completion in
            self?.output.send(.toggleButton(isEnabled: true))
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.output.send(.fetchQuoteDidFail(error: error))
            }
        } receiveValue: { [weak self] quote in
            self?.output.send(.fetchQuoteDidSucceed(quote: quote))
        }.store(in: &cancellables)
    }
}

class QuoteViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    private let vm = QuoteViewModel()
    private let input: PassthroughSubject<QuoteViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .fetchQuoteDidSucceed(quote: let quote):
                    self?.quoteLabel.text = quote.content
                case .fetchQuoteDidFail(error: let error):
                    self?.quoteLabel.text = error.localizedDescription
                case .toggleButton(isEnabled: let isEnabled):
                    self?.refreshButton.isEnabled = isEnabled
                }
            }.store(in: &cancellables)
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        input.send(.refreshButtonDidTap)
    }
    
    //https://api.quotable.io/random
}

protocol QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error>
}

class QuoteService: QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        guard let url = URL(string: "https://api.quotable.io/random") else {
            return Empty().eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map { $0.data }
            .decode(type: Quote.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct Quote: Decodable {
    let content: String
    let author: String
    
}
