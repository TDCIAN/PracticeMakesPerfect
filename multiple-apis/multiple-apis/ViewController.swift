//
//  ViewController.swift
//  multiple-apis
//
//  Created by JeongminKim on 2023/05/30.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAPISequentially()
        fetchAPIAsynchronously()
        fetchAPIWithCombineZip()
    }

    private func fetchAPIWithCombineZip() {
        apiService.fetch().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("fetchAPIWithCombineZip - failure - error: \(error)")
            }
        } receiveValue: { (posts, users) in
            print("fetchAPIWithCombineZip - success - posts: \(posts.count), users: \(users.count)")
        }.store(in: &cancellables)
    }
    
    private func fetchAPISequentially() {
        apiService.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                print("fetchAPISequentially - fetchUsers - success - users: \(users.count)")
                self?.apiService.fetchPosts(completion: { result in
                    switch result {
                    case .success(let posts):
                        print("fetchAPISequentially - fetchPosts - success - posts: \(posts.count)")
                    case .failure(let error):
                        print("fetchAPISequentially - fetchPosts - error: \(error)")
                    }
                })
            case .failure(let error):
                print("fetchAPISequentially - fetchUsers - error: \(error)")
            }
        }
    }

    private func fetchAPIAsynchronously() {
        let group = DispatchGroup()
        var users: [User] = []
        var posts: [Post] = []
        group.enter()
        apiService.fetchUsers { result in
            group.leave()
            switch result {
            case .success(let resultUsers):
                print("fetchAPIAsynchronously - fetchUsers - success - resultUsers: \(resultUsers.count)")
                users = resultUsers
            case .failure(let error):
                print("fetchAPIAsynchronously - fetchUsers - error: \(error)")
            }
        }
        group.enter()
        apiService.fetchPosts { result in
            group.leave()
            switch result {
            case .success(let resultPosts):
                print("fetchAPIAsynchronously - fetchPosts - success - resultPosts: \(resultPosts.count)")
                posts = resultPosts
            case .failure(let error):
                print("fetchAPIAsynchronously - fetchPosts - error: \(error)")
            }
        }
        group.notify(queue: .main) {
            print(">>> done asynchronously - users: \(users.count), posts: \(posts.count)")
        }
    }
}

class APIService {
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let posts = try! JSONDecoder().decode([Post].self, from: data!)
                completion(.success(posts))
            }
        }.resume()
    }
    
    private func fetchPosts() -> AnyPublisher<[Post], Error> {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        
        return URLSession.shared
            .dataTaskPublisher(for: URL(string: urlString)!)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = try! JSONDecoder().decode([User].self, from: data!)
                completion(.success(users))
            }
        }.resume()
    }
    
    func fetchUsers() -> AnyPublisher<[User], Error> {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        
        return URLSession.shared
            .dataTaskPublisher(for: URL(string: urlString)!)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetch() -> AnyPublisher<([Post], [User]), Error> {
        return Publishers
            .Zip(fetchPosts(), fetchUsers())
            .eraseToAnyPublisher()
    }
}

struct User: Decodable, Hashable {
    let id: Int
    let username: String
}

struct Post: Decodable, Hashable {
    let id: Int
    let title: String
}

