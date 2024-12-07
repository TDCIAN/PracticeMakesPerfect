//
//  RxQuoteViewController.swift
//  CombineMVVM
//
//  Created by 김정민 on 4/22/24.
//

import UIKit
import RxSwift
import RxCocoa

class RxQuoteViewModel {
    
    enum Input {
        case viewDidApper
        case refreshButtonDidTap
    }
    
    enum Output {
        case fetchQuoteDidFail(error: Error)
        case fetchQuoteDidSucceed(quote: Quote)
        case toggleButton(isEnabled: Bool)
    }
    
    private let quoteServiceType: RxQuoteServiceType
    private let output = PublishSubject<Output>()
    private let disposeBag = DisposeBag()
    
    init(quoteServiceType: RxQuoteServiceType = RxQuoteService()) {
        self.quoteServiceType = quoteServiceType
    }
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.subscribe(with: self, onNext: { owner, input in
            switch input {
            case .viewDidApper, .refreshButtonDidTap:
                owner.handleGetRandomQuote()
            }
        })
        .disposed(by: self.disposeBag)
        
        return output.asObservable()
    }
    
    private func handleGetRandomQuote() {
        self.output.onNext(.toggleButton(isEnabled: false))
        self.quoteServiceType.getRandomQuote()
            .subscribe(with: self, onNext: { owner, quote in
                owner.output.onNext(.fetchQuoteDidSucceed(quote: quote))
            }, onError: { owner, error in
                owner.output.onNext(.fetchQuoteDidFail(error: error))
            }, onCompleted: { owner in
                owner.output.onNext(.toggleButton(isEnabled: true))
            })
            .disposed(by: self.disposeBag)
    }
}

class RxQuoteViewController: UIViewController {
    
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
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let viewModel = RxQuoteViewModel()
    private let input = PublishSubject<RxQuoteViewModel.Input>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.input.onNext(.viewDidApper)
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
        self.refreshButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.input.onNext(.refreshButtonDidTap)
            })
            .disposed(by: self.disposeBag)
        
        let output = viewModel.transform(input: self.input)
        output
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, output in
                switch output {
                case .fetchQuoteDidSucceed(let quote):
                    owner.quoteLabel.text = quote.content
                case .fetchQuoteDidFail(let error):
                    owner.quoteLabel.text = error.localizedDescription
                case .toggleButton(let isEnabled):
                    owner.refreshButton.isEnabled = isEnabled
                }
            })
            .disposed(by: self.disposeBag)
    }
}

protocol RxQuoteServiceType {
    func getRandomQuote() -> Observable<Quote>
}

class RxQuoteService: RxQuoteServiceType {
    func getRandomQuote() -> Observable<Quote> {
        guard let url = URL(string: "https://api.quotable.io/random") else {
            return .empty()
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .catch { (error: any Error) in
                return .error(error)
            }
            .map { (data: Data) in
                return data
            }
            .map { data -> Quote in
                let decoder = JSONDecoder()
                if let quote = try? decoder.decode(Quote.self, from: data) {
                    return quote
                } else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Decoding error"])
                }
            }
    }
}
