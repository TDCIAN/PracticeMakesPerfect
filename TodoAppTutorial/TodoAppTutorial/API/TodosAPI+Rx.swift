//
//  TodosAPI+Closure.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/18.
//

import Foundation
import MultipartForm
import RxSwift
import RxCocoa
import RxRelay

extension TodosAPI {
    static func fetchTodosWithObservableResult(
        page: Int = 1
    ) -> Observable<Result<BaseListResponse<Todo>, ApiError>> {
        let urlString = baseURL + "todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map({ (urlResponse: HTTPURLResponse, data: Data) -> Result<BaseListResponse<Todo>, ApiError> in
                
                switch urlResponse.statusCode {
                case 401:
                    return .failure(ApiError.unauthorized)
                default:
                    print(#fileID, #function, #line, "- code: \(urlResponse.statusCode)")
                }
                
                if !(200...299).contains(urlResponse.statusCode) {
                    return .failure(ApiError.badStatus(code: urlResponse.statusCode))
                }
                
                do {
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                    let todos = listResponse.data
                    
                    guard let todos = todos,
                          !todos.isEmpty else {
                        return .failure(ApiError.noContent)
                    }
                    return .success(listResponse)
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    return .failure(ApiError.decodingError)
                }
                
            })
    }
    
    static func fetchTodosWithObservable(
        page: Int = 1
    ) -> Observable<BaseListResponse<Todo>> {
        let urlString = baseURL + "todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        return URLSession.shared.rx
            .response(request: urlRequest)
            .map({ (urlResponse: HTTPURLResponse, data: Data) -> BaseListResponse<Todo> in
                
                switch urlResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                default:
                    print(#fileID, #function, #line, "- code: \(urlResponse.statusCode)")
                }
                
                if !(200...299).contains(urlResponse.statusCode) {
                    throw ApiError.badStatus(code: urlResponse.statusCode)
                }
                
                do {
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                    let todos = listResponse.data
                    
                    guard let todos = todos,
                          !todos.isEmpty else {
                        throw ApiError.noContent
                    }
                    return listResponse
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    throw ApiError.decodingError
                }
                
            })
    }
    
    static func fetchATodoWithObservable(
        id: Int
    ) -> Observable<BaseResponse<Todo>> {
        let urlString = baseURL + "todos/" + "\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")

        return URLSession.shared.rx
            .response(request: urlRequest)
            .map { response, data in
                switch response.statusCode {
                case 204:
                    throw ApiError.noContent
                case 401:
                    throw ApiError.unauthorized
                default:
                    print(#fileID, #function, #line, "- fetchATodo code: \(response.statusCode)")
                }
                
                if !(200...299).contains(response.statusCode) {
                    throw ApiError.badStatus(code: response.statusCode)
                }
                
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    return baseResponse
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    throw ApiError.decodingError
                }
            }
    }
    
    static func searchTodosWithObservable(
        searchTerm: String,
        page: Int = 1
//        completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void
    ) -> Observable<BaseListResponse<Todo>> {
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
            return Observable.error(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        return URLSession.shared.rx.response(request: urlRequest).map { response, data in

            switch response.statusCode {
            case 204:
                throw ApiError.noContent
            case 401:
                throw ApiError.unauthorized
            default:
                print(#fileID, #function, #line, "- code: \(response.statusCode)")
            }
            
            if !(200...299).contains(response.statusCode) {
                throw ApiError.badStatus(code: response.statusCode)
            }
            
            do {
                let baseResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                return baseResponse
            } catch(let error) {
                print(#fileID, #function, #line, "- catch error: \(error)")
                throw ApiError.decodingError
            }
        }
    }
    
    
    /// 할 일 추가하기
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료여부
    ///   - completion: 응답 여부
    static func addATodoWithObservable(
        title: String,
        isDone: Bool = false
    ) -> Observable<BaseResponse<Todo>> {
        let urlString = baseURL + "todos"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
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

        return URLSession.shared.rx.response(request: urlRequest).map { httpResponse, data in
            switch httpResponse.statusCode {
            case 204:
                throw ApiError.noContent
            case 401:
                throw ApiError.unauthorized
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            do {
                let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                return baseResponse
            } catch(let error) {
                print(#fileID, #function, #line, "- catch error: \(error)")
                throw ApiError.decodingError
            }
        }
    }
    
    
    /// 할 일 추가하기 - json
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료여부
    ///   - completion: 응답 여부
    static func addATodoJsonWithObservable(
        title: String,
        isDone: Bool = false
    ) -> Observable<BaseResponse<Todo>> {
        let urlString = baseURL + "todos-json"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
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
            return Observable.error(ApiError.jsonEncoding)
        }
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { httpResponse, data in
                switch httpResponse.statusCode {
                case 204:
                    throw ApiError.noContent
                case 401:
                    throw ApiError.unauthorized
                default:
                    print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    return baseResponse
                } catch(let error) {
                    print(#fileID, #function, #line, "- catch error: \(error)")
                    throw ApiError.decodingError
                }
            }
    }
    
    
    /// 할 일 수정하기 - Json
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 타이틀
    ///   - isDone: 완료여부
    ///   - completion: 응답결과
    static func editTodoJsonWithObservable(
        id: Int,
        title: String,
        isDone: Bool = false
    ) -> Observable<BaseResponse<Todo>> {
        let urlString = baseURL + "todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
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
            return Observable.error(ApiError.jsonEncoding)
        }
        
        return URLSession.shared.rx.response(request: urlRequest).map { httpResponse, data in
            
            switch httpResponse.statusCode {
            case 204:
                throw ApiError.noContent
            case 401:
                throw ApiError.unauthorized
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            do {
                let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                return baseResponse
            } catch(let error) {
                print(#fileID, #function, #line, "- catch error: \(error)")
                throw ApiError.decodingError
            }
        }
    }
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 타이틀
    ///   - isDone: 완료여부
    ///   - completion: 응답결과
    static func editTodoWithObservable(
        id: Int,
        title: String,
        isDone: Bool = false
    ) -> Observable<BaseResponse<Todo>> {
        let urlString = baseURL + "todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
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
        return URLSession.shared.rx.response(request: urlRequest).map { httpResponse, data in
            switch httpResponse.statusCode {
            case 204:
                throw ApiError.noContent
            case 401:
                throw ApiError.unauthorized
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            do {
                let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                return baseResponse
            } catch(let error) {
                print(#fileID, #function, #line, "- catch error: \(error)")
                throw ApiError.decodingError
            }
        }
    }
    
    /// 삭제하기
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - completion: 응답결과
    static func deleteATodoWithObservable(
        id: Int
    ) -> Observable<BaseResponse<Todo>> {
        let urlString = baseURL + "todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        return URLSession.shared.rx.response(request: urlRequest).map { httpResponse, data in
            switch httpResponse.statusCode {
            case 204:
                throw ApiError.noContent
            case 401:
                throw ApiError.unauthorized
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            do {
                let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                return baseResponse
            } catch(let error) {
                print(#fileID, #function, #line, "- catch error: \(error)")
                throw ApiError.decodingError
            }
        }
    }
    
    /// 할 일 추가 후 모든 할 일 가져오기
    /// - Parameters:
    ///   - title:
    ///   - isDone:
    ///   - completion:
    static func addTodoAndFetchTodosWithObservable(
        title: String,
        isDone: Bool = false
//        completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void
    ) -> Observable<[Todo]> {
        let disposeBag = DisposeBag()
        
        return self.addATodoWithObservable(title: title)
            .flatMapLatest { _ in
                self.fetchTodosWithObservable()
            }
            .compactMap { $0.data }
            .catch({ err in
                return Observable.just([])
            })
            .share(replay: 1)
    }

    /// 클로저 기반 api 동시 처리
    /// 선택된 할 일들 삭제하기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할 일 아이디들
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSelectedTodosWithObservable(
        selectedTodoIds: [Int]
//        completion: @escaping ([Int]) -> Void
    ) -> Observable<[Int]> {
        
        // 1. 매개변수 배열 -> Observable 스트림 배열
        // 2. 배열로 단일 API들 호출
        let apiCallObservables = selectedTodoIds.map { id -> Observable<Int?> in
            return self.deleteATodoWithObservable(id: id)
                .map { $0.data?.id }
                .catchAndReturn(nil)
        }
        
        return Observable.zip(apiCallObservables)
            .map { // Observable<[Int?]>
                $0.compactMap { $0 } // Int
            } // Observable[Int]
        
    }
    
    static func deleteSelectedTodosWithObservableMerge(selectedTodoIds: [Int]) -> Observable<Int> {
        let apiCallObservables = selectedTodoIds.map { id -> Observable<Int?> in
            return self.deleteATodoWithObservable(id: id)
                .map { $0.data?.id }
                .catchAndReturn(nil)
        }
        
        return Observable.merge(apiCallObservables).compactMap { $0 }
    }
    
    
    /// 선택한 일들 가져오기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할 일 아이디들
    ///   - completion: 응답 결과
    static func fetchSelectedTodosWithObservable(
        selectedTodoIds: [Int]
//        completion: @escaping (Result<[Todo], ApiError>) -> Void
    ) -> Observable<[Todo]> {
        
        let apiCallObservables = selectedTodoIds.map { id -> Observable<Todo?> in
            return self.fetchATodoWithObservable(id: id)
                .map { $0.data }
                .catchAndReturn(nil)
        }
        
        return Observable.zip(apiCallObservables).map { $0.compactMap { $0 } }
    }
    
    static func fetchSelectedTodosObservableMerge(selectedTodoIds: [Int]) -> Observable<Todo> {
        let apiCallObservable = selectedTodoIds.map { id -> Observable<Todo?> in
            return self.fetchATodoWithObservable(id: id)
                .map { $0.data }
                .catchAndReturn(nil)
        }
        
        return Observable.merge(apiCallObservable).compactMap { $0 }
    }
}

