//
//  SearchViewModel.swift
//  GithubUserSearch
//
//  Created by JeongminKim on 2022/11/22.
//

import Foundation
import Combine
import UIKit

final class SearchViewModel {
    
    init(network: NetworkService) {
        self.network = network
    }
    
    let network: NetworkService
    
    var subscriptions = Set<AnyCancellable>()
    let users = CurrentValueSubject<[SearchResult], Never>([])
    
    func search(keyword: String) {
        let resource: Resource<SearchUserResponse> = Resource(
            base: "https://api.github.com/",
            path: "search/users",
            params: ["q": keyword],
            header: ["Content-Type": "application/json"]
        )
        
        network.load(resource)
            .map { $0.items }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("network - completion - error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [unowned self] userList in
                self.users.send(userList)
            })
            .store(in: &subscriptions)
    }
    
}
