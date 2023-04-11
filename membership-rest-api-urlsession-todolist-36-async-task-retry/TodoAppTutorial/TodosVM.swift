//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by Jeff Jeong on 2022/11/20.
//

import Foundation
import Combine
import RxSwift
import RxCocoa
import RxRelay
import RxCombine

class TodosVM: ObservableObject {
    
    var disposeBag = DisposeBag()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(){
        print(#fileID, #function, #line, "- ")
        
        
        
        
//        let fetchTodosTask = Task.retry(retryCount: 3, delay: 2, when: { err in
//                                if case TodosAPI.ApiError.unauthorized = err {
//                                    return true
//                                }
//                                return false
//                            }, asyncWork: {
//                                try await TodosAPI.fetchTodosWithAsync(page: 999)
//                            })
        let fetchTodosTask = Task.retry(retryCount: 3, delay: 2, asyncWork: {
                                try await TodosAPI.fetchTodosWithAsync(page: 999)
                            })
        
        Task {
            do {
                let result = try await fetchTodosTask.value
                print("retry - :: result call : \(result)")
            } catch {
                print("retry - :: error call : \(error)")
            }
        }
        

    }// init
    
    
    
    /// API 에러처리
    /// - Parameter err: API 에러
    fileprivate func handleError(_ err: Error) {
        
        if err is TodosAPI.ApiError {
            let apiError = err as! TodosAPI.ApiError
            
            print("handleError : err : \(apiError.info)")
            
            switch apiError {
            case .noContent:
                print("컨텐츠 없음")
            case .unauthorized:
                print("인증안됨")
            case .decodingError:
                print("디코딩 에러입니당ㅇㅇ")
            default:
                print("default")
            }
        }
        
    }// handleError
    
}
