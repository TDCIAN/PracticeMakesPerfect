//
//  TodosAPI.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/13.
//

import Foundation

enum TodosAPI {
    
    static let version = "v1/"
    
    #if DEBUG
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    #else
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    #endif

    enum ApiError: Error {
        case badUrl
        case parsingError
        case noContentError
        case decodingError
        case basStatus(code: Int)
    }
    
    static func fetchTodos(
        page: Int = 1,
        completion: @escaping (Result<TodosResponse, ApiError>) -> Void
    ) {
        let urlString = baseURL + "todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let jsonData = data {
                do {
                    let todosResponse = try JSONDecoder().decode(TodosResponse.self, from: jsonData)
                    let modelObjects = todosResponse.data
                    print(#fileID, #function, #line, "- modelObjects: \(modelObjects)")
                    completion(.success(todosResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            } else {
                print(#fileID, #function, #line, "- request error: \(error)")
                completion(.failure(.noContentError))
            }
        }.resume()
    }
}
