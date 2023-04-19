//
//  TodosAPI+Closure.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/18.
//

import Foundation
import MultipartForm

extension TodosAPI {
    static func fetchTodos(
        page: Int = 1,
        completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void
    ) {
        let urlString = baseURL + "todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.notAllowedUrl))
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
        let urlString = baseURL + "todos/" + "\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.notAllowedUrl))
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
            print("펫치어투두 - 아이디: \(id), 데이터: \(data)")
            switch httpResponse.statusCode {
            case 204:
                return completion(.failure(ApiError.noContent))
            case 401:
                return completion(.failure(ApiError.unauthorized))
            default:
                print(#fileID, #function, #line, "- fetchATodo code: \(httpResponse.statusCode)")
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
            return completion(.failure(.notAllowedUrl))
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
        let urlString = baseURL + "/todos"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.notAllowedUrl))
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
            return completion(.failure(.notAllowedUrl))
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
            return completion(.failure(ApiError.jsonEncoding))
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
            return completion(.failure(.notAllowedUrl))
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
            return completion(.failure(ApiError.jsonEncoding))
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
            return completion(.failure(.notAllowedUrl))
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
            return completion(.failure(.notAllowedUrl))
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
    
    /// 할 일 추가 후 모든 할 일 가져오기
    /// - Parameters:
    ///   - title:
    ///   - isDone:
    ///   - completion: 
    static func addTodoAndFetchTodos(
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void
    ) {
        // 1
        self.addATodo(title: title) { result in
            switch result {
                // 1-1
            case .success(_):
                // 2
                self.fetchTodos {
                    switch $0 {
                        // 2-1
                    case .success(let data):
                        completion(.success(data))
                        // 2-2
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                // 1-2
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// 클로저 기반 api 동시 처리
    /// 선택된 할 일들 삭제하기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할 일 아이디들
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSelectedTodos(
        selectedTodoIds: [Int],
        completion: @escaping ([Int]) -> Void
    ) {
        let group = DispatchGroup()
        var deletedTodoIds: [Int] = []
        
        selectedTodoIds.forEach { aTodoId in
            
            // 디스패치 그룹에 넣음
            group.enter()
            
            self.deleteATodo(id: aTodoId) { result in
                switch result {
                case .success(let response):
                    if let todoId = response.data?.id {
                        deletedTodoIds.append(todoId)
                    }
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error)")
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("모든 삭제 API 완료 됨")
            completion(deletedTodoIds)
        }
    }
    
    
    /// 선택한 일들 가져오기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할 일 아이디들
    ///   - completion: 응답 결과
    static func fetchSelectedTodos(
        selectedTodoIds: [Int],
        completion: @escaping (Result<[Todo], ApiError>) -> Void
    ) {
        let group = DispatchGroup()
        // 가져온 할 일들
        var fetchedTodos: [Todo] = []
        // 에러들
        var apiErrors: [ApiError] = []
        // 응답 결과들
        var apiResults: [Int: Result<BaseResponse<Todo>, ApiError>] = [:]
        
        selectedTodoIds.forEach { aTodoId in
            
            // 디스패치 그룹에 넣음
            group.enter()
            
            self.fetchATodo(id: aTodoId) { result in
                switch result {
                case .success(let response):
                    if let todo = response.data {
                        fetchedTodos.append(todo)
                    }
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error)")
                    apiErrors.append(error)
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("모든 fetch API 완료 됨")
            
            // 만약 에러가 있다면 에러 올려주기
            if !apiErrors.isEmpty {
                if let firstError = apiErrors.first {
                    completion(.failure(firstError))
                }
            }
            completion(.success(fetchedTodos))
        }
    }
}
