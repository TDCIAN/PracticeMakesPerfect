//
//  TodosAPI.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/13.
//

import Foundation
import MultipartForm

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
        case jsonEncodingError
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
            case .jsonEncodingError:
                return "유효한 JSON 형식이 아닙니다."
            }
        }
    }
    
    static func fetchTodos(
        page: Int = 1,
        completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void
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
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: jsonData)
                    let todos = listResponse.data
                    
                    guard let todos = todos,
                          !todos.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(listResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    static func fetchATodo(
        id: Int,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        let urlString = baseURL + "todos/" + "id=\(id)"
        
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
            case 204:
                return completion(.failure(ApiError.noContent))
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
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    static func searchTodos(
        searchTerm: String,
        page: Int = 1,
        completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void
    ) {
//        let urlString = baseURL + "todos/search" + "?query=\(searchTerm)" + "&page=\(page)" +
        
        let requestUrl = URL(
            baseUrl: baseURL + "todos/search/",
            queryItems: [
                "query": searchTerm,
                "page": "\(page)"
            ]
        )
        
//        var urlComponents = URLComponents(string: baseURL + "/todos/search")
//        urlComponents?.queryItems = [
//            URLQueryItem(name: "query", value: searchTerm),
//            URLQueryItem(name: "page", value: "\(page)")
//        ]

        guard let url = requestUrl else {
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
            case 204:
                return completion(.failure(ApiError.noContent))
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
                    let baseResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    
    /// 할 일 추가하기
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료여부
    ///   - completion: 응답 여부
    static func addATodo(
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        let urlString = baseURL + "todos"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        let form = MultipartForm(parts: [
            MultipartForm.Part(name: "title", value: title),
            MultipartForm.Part(name: "is_done", value: "\(isDone)")
        ])
        
        
        print(#fileID, #function, #line, "- form.contentType: \(form.contentType)")
        
        urlRequest.addValue(form.contentType, forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = form.bodyData
        
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
            case 204:
                return completion(.failure(ApiError.noContent))
            case 401:
                return completion(.failure(ApiError.unauthorized))
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    
    /// 할 일 추가하기 - json
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료여부
    ///   - completion: 응답 여부
    static func addATodoJson(
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        let urlString = baseURL + "todos-json"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestParams: [String: Any] = [
            "title": title,
            "is_done": "\(isDone)"
        ]
        do {
            let jsonData = try? JSONSerialization.data(
                withJSONObject: requestParams,
                options: .prettyPrinted
            )
            urlRequest.httpBody = jsonData
        } catch {
            return completion(.failure(ApiError.jsonEncodingError))
        }
        
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
            case 204:
                return completion(.failure(ApiError.noContent))
            case 401:
                return completion(.failure(ApiError.unauthorized))
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    
    /// 할 일 수정하기 - Json
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 타이틀
    ///   - isDone: 완료여부
    ///   - completion: 응답결과
    static func editTodoJson(
        id: Int,
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        let urlString = baseURL + "todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestParams: [String: Any] = [
            "title": title,
            "is_done": "\(isDone)"
        ]
        do {
            let jsonData = try? JSONSerialization.data(
                withJSONObject: requestParams,
                options: .prettyPrinted
            )
            urlRequest.httpBody = jsonData
        } catch {
            return completion(.failure(ApiError.jsonEncodingError))
        }
        
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
            case 204:
                return completion(.failure(ApiError.noContent))
            case 401:
                return completion(.failure(ApiError.unauthorized))
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 타이틀
    ///   - isDone: 완료여부
    ///   - completion: 응답결과
    static func editTodo(
        id: Int,
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        let urlString = baseURL + "todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestParams: [String: String] = [
            "title": title,
            "is_done": "\(isDone)"
        ]
        urlRequest.percentEncodeParameters(parameters: requestParams)
        
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
            case 204:
                return completion(.failure(ApiError.noContent))
            case 401:
                return completion(.failure(ApiError.unauthorized))
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    /// 삭제하기
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - completion: 응답결과
    static func deleteATodo(
        id: Int,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        let urlString = baseURL + "todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
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
            case 204:
                return completion(.failure(ApiError.noContent))
            case 401:
                return completion(.failure(ApiError.unauthorized))
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    completion(.success(baseResponse))
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
