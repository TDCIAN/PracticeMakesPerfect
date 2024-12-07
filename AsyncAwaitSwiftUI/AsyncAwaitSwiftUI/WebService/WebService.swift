//
//  WebService.swift
//  AsyncAwaitSwiftUI
//
//  Created by 김정민 on 5/2/24.
//

import Foundation
import Combine
import RxSwift
import RxCocoa

final class WebService {
    
    static func getUsersData() async throws -> [UserModel] {
        let urlString = "https://api.github.com/users"
        guard let url = URL(string: urlString) else {
            throw ErrorCases.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw ErrorCases.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([UserModel].self, from: data)
        } catch {
            throw ErrorCases.invalidData
        }
    }
    
    static func getUsersDataWithCombine() -> AnyPublisher<[UserModel], Error> {
        let urlString = "https://api.github.com/users"
        guard let url = URL(string: urlString) else {
            return Fail(error: ErrorCases.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { (error: URLError) in
                return Fail(error: ErrorCases.invalidResponse).eraseToAnyPublisher()
            }
            .map { $0.data }
            .decode(type: [UserModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func getUsersDataWithRx() -> Observable<[UserModel]> {
        let urlString = "https://api.github.com/users"
        guard let url = URL(string: urlString) else {
            return Observable.error(ErrorCases.invalidURL)
        }
        return URLSession.shared.rx.response(request: URLRequest(url: url))
            .flatMapLatest { (response: HTTPURLResponse, data: Data) in
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        return Observable.just(try decoder.decode([UserModel].self, from: data))
                    } catch {
                        return Observable.error(ErrorCases.invalidData)
                    }
                } else {
                    return Observable.error(ErrorCases.invalidResponse)
                }
            }
    }
}
