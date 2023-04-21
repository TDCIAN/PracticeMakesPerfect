//
//  TodosAPI+Combine.swift
//  TodoAppTutorial
//
//  Created by Jeff Jeong on 2022/11/26.
//

import Foundation
import MultipartForm
import RxSwift
import RxCocoa
import Combine
import CombineExt

extension TodosAPI {
    
    /// 모든 할 일 목록 가져오기
    static func fetchTodosWithAsyncResult(page: Int = 1) async -> Result<BaseListResponse<Todo>, ApiError>{
        
        // 1. urlRequest 를 만든다
        
        let urlString = baseURL + "/todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return .failure(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession 으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return .failure(ApiError.unknown(nil))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return .failure(ApiError.unauthorized)
            default:
                print(#fileID, #function, #line, "- httpResponse.statusCode: \(httpResponse.statusCode)")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return .failure(ApiError.badStatus(code: httpResponse.statusCode))
            }
            
            let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
            let todos = listResponse.data
            
            guard let todos = todos,
                  !todos.isEmpty else {
                return .failure(ApiError.noContent)
            }
            
            return .success(listResponse)
            
        } catch {
            if let _ = error as? DecodingError {
                return .failure(ApiError.decodingError)
            }
            
            return .failure(ApiError.unknown(error))
        }

    }
    
    // 구독 X
    // 데이터 스트림 즉 물줄기만 변경
    /// 모든 할 일 목록 가져오기
    static func fetchTodosWithAsync(page: Int = 1) async throws -> BaseListResponse<Todo> {
        
        // 1. urlRequest 를 만든다
        
        let urlString = baseURL + "/todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                throw ApiError.unknown(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
            let todos = listResponse.data
            
            guard let todos = todos,
                  !todos.isEmpty else {
                throw ApiError.noContent
            }
            
            return listResponse
            
        } catch {
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            
            throw ApiError.unknown(error)
        }
    }
    
    
    
    
    /// 특정 할 일 가져오기
    static func fetchATodoWithAsync(id: Int) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest 를 만든다
        
        let urlString = baseURL + "/todos" + "/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("bad status code")
                throw ApiError.unknown(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            case 204:
                throw ApiError.noContent
                
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)

            return baseResponse

        } catch {
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknown(error)
        }

    }
    
    /// 할 일 검색하기
    static func searchTodosWithAsync(searchTerm: String, page: Int = 1) async throws -> BaseListResponse<Todo> {
        
        // 1. urlRequest 를 만든다
        let requestUrl = URL(baseUrl: baseURL + "/todos/search", queryItems: ["query" : searchTerm,
                                                                              "page" : "\(page)"])
        guard let url = requestUrl else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("bad status code")
                throw ApiError.unknown(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            let baseListResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
            
            return baseListResponse
            
        } catch {
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknown(error)
        }
    }
    
    /// 할 일 추가하기
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoWithAsync(
        title: String,
        isDone: Bool = false
    ) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest 를 만든다
        
        let urlString = baseURL + "/todos"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        let form = MultipartForm(parts: [
            MultipartForm.Part(name: "title", value: title),
            MultipartForm.Part(name: "is_done", value: "\(isDone)")
        ])
        
        print("form.contentType : \(form.contentType)")
        
        urlRequest.addValue(form.contentType, forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = form.bodyData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.unknown(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            case 204:
                throw ApiError.noContent
                
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            
            return baseResponse
            
        } catch {
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknown(nil)
        }

    }
    
    /// 할 일 추가하기 - Json
    /// - Parameters:
    ///   - title: 할일 타이틀
    ///   - isDone: 할일 완료여부
    ///   - completion: 응답 결과
    static func addATodoJsonWithAsync(
        title: String,
        isDone: Bool = false
    ) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest 를 만든다
        
        let urlString = baseURL + "/todos-json"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : Any] = ["title": title, "is_done" : "\(isDone)"]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            
            urlRequest.httpBody = jsonData
            
        } catch {
            throw ApiError.jsonEncoding
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.unknown(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            case 204:
                throw ApiError.noContent
                
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            
            return baseResponse
            
        } catch {
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknown(error)
        }
        
    }
    
    /// 할 일 수정하기 - Json
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 타이틀
    ///   - isDone: 완료여부
    ///   - completion: 응답결과
    static func editTodoJsonWithAsync(
        id: Int,
        title: String,
        isDone: Bool = false
    ) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest 를 만든다
        
        let urlString = baseURL + "/todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : Any] = ["title": title, "is_done" : "\(isDone)"]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            
            urlRequest.httpBody = jsonData
            
        } catch {
            throw ApiError.jsonEncoding
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("bad status code")
                throw ApiError.unknown(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            case 204:
                throw ApiError.noContent
                
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            
            return baseResponse
            
        } catch {
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknown(error)
        }
    }
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 타이틀
    ///   - isDone: 완료여부
    ///   - completion: 응답결과
    static func editTodoWithAsync(
        id: Int,
        title: String,
        isDone: Bool = false
    ) async throws -> BaseResponse<Todo> {
        
        // 1. urlRequest 를 만든다
        
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : String] = ["title": title, "is_done" : "\(isDone)"]
        
        urlRequest.percentEncodeParameters(parameters: requestParams)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.unknown(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            case 204:
                throw ApiError.noContent
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            
            return baseResponse
        } catch {
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknown(error)
        }
    }
    
    /// 할 일 삭제하기 - DELETE
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - completion: 응답결과
    static func deleteATodoWithAsync(
        id: Int
    ) async throws -> BaseResponse<Todo> {
        
        print(#fileID, #function, #line, "- deleteATodo 호출됨 / id: \(id)")
        
        // 1. urlRequest 를 만든다
        
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("bad status code")
                throw ApiError.unknown(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            case 204:
                throw ApiError.noContent
                
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
            
            return baseResponse
            
        } catch {
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            
            throw ApiError.unknown(nil)
        }
    }
    
    
    /// 할일 추가 -> 모든 할일 가져오기 - 에러함께
    /// - Parameters:
    ///   - title:
    ///   - isDone:
    ///   - completion:
    static func addATodoAndFetchTodosWithAsync(
        title: String,
        isDone: Bool = false
    ) async throws -> [Todo] {
        
        let firstResult = try await addATodoWithAsync(title: title)
        let secondResult = try await fetchTodosWithAsync()
        
        guard let finalResult = secondResult.data else {
            throw ApiError.noContent
        }
        
        return finalResult
    }
    
    /// 할일 추가 -> 모든 할일 가져오기 - NO 에러
    /// - Parameters:
    ///   - title:
    ///   - isDone:
    ///   - completion:
    static func addATodoAndFetchTodosWithAsyncNoError(
        title: String,
        isDone: Bool = false
    ) async throws -> [Todo] {
        
        do {
            let firstResult = try await addATodoWithAsync(title: title)
            let secondResult = try await fetchTodosWithAsync()
            guard let finalResult = secondResult.data else {
                return []
            }
            return finalResult
        } catch {
            if let _ = error as? ApiError {
                return []
            }
            return []
        }
    }
    
    /// 할일 추가 -> 모든 할일 가져오기 - NO 에러 switchToLatest
    /// - Parameters:
    ///   - title:
    ///   - isDone:
    ///   - completion:
    static func addATodoAndFetchTodosWithAsyncNoErrorSwitchToLatest(title: String,
                                      isDone: Bool = false) -> AnyPublisher<[Todo], Never>{
        
        // 1
        return self.addATodoWithPublisher(title: title)
                    .map { _ in
                        self.fetchTodosWithPublisher()
                    } // BaseListResponse<Todo>
                    .switchToLatest()
                    .compactMap{ $0.data } // [Todo]
//                    .catch({ err in
//                        print("TodosAPI - catch : err : \(err)")
//                        return Just([]).eraseToAnyPublisher()
//                    })
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
    }
    
    /// 클로져 기반 api 동시 처리
    /// 선택된 할일들 삭제하기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디들
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSelectedTodosWithAsync(selectedTodoIds: [Int]) -> Observable<[Int]>{
        
        //1. 매개변수 배열 -> Observable 스트림 배열
        
        //2. 배열로 단일 api들 호출
        let apiCallObservables = selectedTodoIds.map { id -> Observable<Int?> in
            return self.deleteATodoWithObservable(id: id)
                .map{ $0.data?.id } // Int?
                .catchAndReturn(nil)
//                .catch { err in
//                    return Observable.just(nil)
//                }
        }
        
        return Observable.zip(apiCallObservables)
                    .map{ // Observable<[Int?]>
                        $0.compactMap{ $0 } // Int
                    } // Observable<[Int]>
    }
    
    static func deleteSelectedTodosWithAsyncTaskGroupWithError(selectedTodoIds: [Int]) async throws -> [Int] {
        try await withThrowingTaskGroup(of: Int?.self) { (group: inout ThrowingTaskGroup<Int?, Error>) -> [Int] in
            for aTodoId in selectedTodoIds {
                group.addTask {
                    let childTaskResult = try await self.deleteATodoWithAsync(id: aTodoId)
                    return childTaskResult.data?.id
                }
            }
            
            var deleteTodoIds: [Int] = []
            
            for try await singleValue in group {
                if let value = singleValue {
                    deleteTodoIds.append(value)
                }
            }
            
            return deleteTodoIds
        }
    }
    
    static func deleteSelectedTodosWithAsyncTaskGroupNoError(selectedTodoIds: [Int]) async -> [Int] {
        await withTaskGroup(of: Int?.self, body: { (group: inout TaskGroup<Int?>) -> [Int] in
            for aTodoId in selectedTodoIds {
                group.addTask {
                    do {
                        let childTaskResult = try await self.deleteATodoWithAsync(id: aTodoId)
                        return childTaskResult.data?.id
                    } catch {
                        return nil
                    }
                }
            }
            
            var deleteTodoIds: [Int] = []
            
            for await singleValue in group {
                if let value = singleValue {
                    deleteTodoIds.append(value)
                }
            }
            return deleteTodoIds
        })
    }
    
    static func deleteSelectedTodosWithAsyncMergeWithError(selectedTodoIds: [Int]) -> AnyPublisher<Int, ApiError>{
        
        //1. 매개변수 배열 -> Observable 스트림 배열
        
        //2. 배열로 단일 api들 호출
        let apiCallPublishers : [AnyPublisher<Int?, ApiError>]
        = selectedTodoIds.map { id -> AnyPublisher<Int?, ApiError> in
            return self.deleteATodoWithPublisher(id: id)
                .map{ $0.data?.id } // Int?
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(apiCallPublishers).compactMap{ $0 }.eraseToAnyPublisher()
    }
    
    static func deleteSelectedTodosWithAsyncMerge(selectedTodoIds: [Int]) -> AnyPublisher<Int, Never>{
        
        //1. 매개변수 배열 -> Observable 스트림 배열
        
        //2. 배열로 단일 api들 호출
        let apiCallPublishers : [AnyPublisher<Int?, Never>]
        = selectedTodoIds.map { id -> AnyPublisher<Int?, Never> in
            return self.deleteATodoWithPublisher(id: id)
                .map{ $0.data?.id } // Int?
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(apiCallPublishers).compactMap{ $0 }.eraseToAnyPublisher()
    }
    
    static func deleteSelectedTodosWithAsyncZip(selectedTodoIds: [Int]) -> AnyPublisher<[Int], Never>{

        //1. 매개변수 배열 -> Observable 스트림 배열

        //2. 배열로 단일 api들 호출
        let apiCallPublishers : [AnyPublisher<Int?, Never>]
        = selectedTodoIds.map { id -> AnyPublisher<Int?, Never> in
            return self.deleteATodoWithPublisher(id: id)
                .map{ $0.data?.id } // Int?
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }

        return apiCallPublishers.zip().map{ $0.compactMap{ $0 } }.eraseToAnyPublisher()
    }
    
    /// Rx 기반 api 동시 처리
    /// 선택된 할일들 가져오기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디들
    ///   - completion: 응답 결과
//    static func fetchSelectedTodosAsync(selectedTodoIds: [Int]) -> AnyPublisher<[Todo], Never>{
//
//        //1. 매개변수 배열 -> Observable 스트림 배열
//
//        //2. 배열로 단일 api들 호출
//        let apiCallPublishers = selectedTodoIds.map { id -> AnyPublisher<Todo?, Never> in
//            return self.fetchATodoWithAsync(id: id)
//                .map{ $0.data } // Todo?
//                .replaceError(with: nil)
//                .eraseToAnyPublisher()
//        }
//
//        return apiCallPublishers.zip().map{ $0.compactMap{ $0 } }.eraseToAnyPublisher()
//    }
    
    /// Rx 기반 api 동시 처리
    /// 선택된 할일들 가져오기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 아이디들
    ///   - completion: 응답 결과
//    static func fetchSelectedTodosAsyncMerge(selectedTodoIds: [Int]) -> AnyPublisher<Todo, Never>{
//
//        //1. 매개변수 배열 -> Observable 스트림 배열
//
//        //2. 배열로 단일 api들 호출
//        let apiCallPublishers = selectedTodoIds.map { id -> AnyPublisher<Todo?, Never> in
//            return self.fetchATodoWithAsync(id: id)
//                .map{ $0.data } // Todo?
//                .replaceError(with: nil)
//                .eraseToAnyPublisher()
//        }
//
//        return Publishers.MergeMany(apiCallPublishers).compactMap{ $0 }.eraseToAnyPublisher()
//    }
}

//extension TodosAPI {
//    // 구독 O
//    // 받은 이벤트 기반으로 async 로 보냄
//    /// combine -> async
//    static func fetchTodosWithPublisherToAsync(page: Int = 1) async throws -> BaseListResponse<Todo> {
//
//        return try await withCheckedThrowingContinuation({ (continuation : CheckedContinuation<BaseListResponse<Todo>, Error>) in
//
//            var cancellable : AnyCancellable? = nil
//
//            //1. 기존 publisher 이벤트를 구독
//            cancellable = fetchTodosWithPublisher(page: page)
//                // 2. 들어온 이벤트의 결과에 따라 async 이벤트 처리
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        print("finished")
//                    case .failure(let failure):
//                        print("failure : \(failure)")
//                        continuation.resume(throwing: failure)
//                    }
//                    cancellable?.cancel()
//                }, receiveValue: { response in
//                    print("receiveValue : \(response)")
//                    continuation.resume(returning: response)
//                })
//        })
//
//    }
//}


extension AnyPublisher {
    
//    func toAsync() async throws -> Output {
//
//        return try await withCheckedThrowingContinuation({ (continuation : CheckedContinuation<Output, Error>) in
//
//            var cancellable : AnyCancellable? = nil
//
//            //1. 기존 publisher 이벤트를 구독
//            cancellable = first()
//                // 2. 들어온 이벤트의 결과에 따라 async 이벤트 처리
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let failure):
//                        continuation.resume(throwing: failure)
//                    }
//                    cancellable?.cancel()
//                }, receiveValue: { response in
//                    continuation.resume(returning: response)
//                })
//        })
//    }
}

//MARK: - Combine Retry
extension Publisher {
    
    
//    func retryWithDelayAndCondition<T, E>(retryCount: Int = 1,
//                                    delay: Int = 1,
//                                    when: ((Error) -> Bool)? = nil
//    ) -> Publishers.TryCatch<Self, AnyPublisher<T, E>> where T == Self.Output, E == Self.Failure {
//        return self.tryCatch({ err -> AnyPublisher<T, E> in
//
//            // 조건
//            guard (when?(err) ?? true) else {
//                throw err
//            }
//
//            return Just(Void())
//                .delay(for: .seconds(delay), scheduler: DispatchQueue.main) // 딜레이
//                .flatMap { _ in
//                    return self
//                }
//                .retry(retryCount - 1)
//                .eraseToAnyPublisher()
//            })
//    }
    
}
