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
        case noContent
        case decodingError
        case unauthorized
        case badStatus(code: Int)
        case unknown(_ err: Error?)
        
        var info: String {
            switch self {
            case .badUrl:
                return "잘못된 URL입니다."
            case .noContent:
                return "데이터가 없습니다."
            case .decodingError:
                return "디코딩 에러입니다."
            case .unauthorized:
                return "인증되지 않은 사용자입니다."
            case .badStatus(code: let code):
                return "에러 상태코드: \(code)"
            case .unknown(let err):
                return "알 수 없는 에러입니다. \(err)"
            }
        }
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
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
            
            if let error = err {
                print(#fileID, #function, #line, "- request error: \(err)")
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print(#fileID, #function, #line, "- bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unauthorized))
            default:
                print(#fileID, #function, #line, "- code: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    let todosResponse = try JSONDecoder().decode(TodosResponse.self, from: jsonData)
                    let todos = todosResponse.data
                    
                    guard let todos = todos,
                          !todos.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(todosResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
