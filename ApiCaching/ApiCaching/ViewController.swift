//
//  ViewController.swift
//  ApiCaching
//
//  Created by 김정민 on 4/1/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private let postsService: PostsService = .init()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.postsService.fetchPosts().sink { completion in
            if case .failure(let error) = completion {
                print(">>> failure error - \(error)")
            }
        } receiveValue: { (posts: [Post]) in
            print(">>> posts count: \(posts.count)")
        }
        .store(in: &self.cancellables)
    }
}

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class PostsService {
    
    private let remoteService: PostsRemoteService = .init()
    private let offlineService: PostsOfflineService = .init()
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        return self.remoteService.fetchPosts().catch { [weak self] error in
            print(">>> get offline because of an error - error: \(error)")
            return self?.offlineService.getOffline() ?? Empty().eraseToAnyPublisher()
        }.handleEvents(receiveOutput: { [weak self] posts in
            print(">>> save posts offline - posts.count: \(posts.count)")
            self?.offlineService.saveOffline(posts: posts)
        })
        .eraseToAnyPublisher()
    }
}

class PostsRemoteService {
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        
        let url = URL(string: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

class PostsOfflineService {
    
    private let defaults = UserDefaults.standard
    private let key = "posts"
    
    func saveOffline(posts: [Post]) {
        if let encoded = try? JSONEncoder().encode(posts) {
            self.defaults.set(encoded, forKey: key)
        }
    }
    
    func getOffline() -> AnyPublisher<[Post], Error> {
        do {
            guard let data: Data = self.defaults.object(forKey: self.key) as? Data else {
                return Just([])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            let decoded: [Post] = try JSONDecoder().decode([Post].self, from: data)
            return Just(decoded)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
