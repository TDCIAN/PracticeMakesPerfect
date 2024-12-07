//
//  ContentViewModel.swift
//  CryptoAsyncAwait
//
//  Created by 김정민 on 5/2/24.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var coins = [Coin]()
    @Published var error: Error?
    
    private let pageLimit = 20
    private var page = 0
    
    let BASE_URL = "https://api.coingecko.com/api/v3/coins/"
    
    var urlString: String {
        return  "\(BASE_URL)markets?vs_currency=usd&order=market_cap_desc&per_page=\(self.pageLimit)&page=\(self.page)&price_change_percentage=24h"
    }
    
    init() {
//        self.fetchCoinsWithURLSession()
//        self.loadData()
        self.fetchCoinsCombine()
    }
    
    func handleRefresh() {
        self.coins.removeAll()
        self.page = 0
        self.loadData()
    }
}

// MARK: - Combine
extension ContentViewModel {
    func fetchCoinsCombine() {
        guard let url = URL(string: self.urlString) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    self.page += 1
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { [weak self] (data: Data, response: URLResponse) in
                guard let self else { return }
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    self.error = CoinError.serverError
                    return
                }
                guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                    self.error = CoinError.invalidData
                    return
                }
                self.coins.append(contentsOf: coins)
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - Async / Await
extension ContentViewModel {
    
    @MainActor
    func fetchCoinsAsync() async throws {
        do {
            self.page += 1
            guard let url = URL(string: self.urlString) else {
                throw CoinError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw CoinError.serverError
            }
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                throw CoinError.invalidData
            }
            self.coins.append(contentsOf: coins)
        } catch {
            self.error = error
        }
    }
    
    func loadData() {
        Task(priority: .medium) {
            try await self.fetchCoinsAsync()
        }
    }
}

// MARK: - URLSession
extension ContentViewModel {
    func fetchCoinsWithURLSession() {
        guard let url = URL(string: self.urlString) else {
            print("DEBUG: Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("DEBUG: Error: \(error.localizedDescription)")
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                      statusCode == 200 else {
                    print("DEBUG: Server Error - status code: \((response as? HTTPURLResponse)?.statusCode)")
                    return
                }
                
                guard let data = data else {
                    print("DEBUG: Invalid data")
                    return
                }
                
                guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                    print("DEBUG: Invalid data")
                    return
                }
                
                self.coins = coins
            }
        }
        .resume()
    }
}
