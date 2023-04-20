//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/13.
//

import Foundation
import Combine
import RxSwift
import RxCocoa

class TodosVM: ObservableObject {
    private let disposeBag = DisposeBag()
    var subscriptions = Set<AnyCancellable>()
    
    init() {        
        print(#fileID, #function, #line, "- ")
        
        Task {
            do {
                let response = try await TodosAPI.deleteSelectedTodosWithAsyncTaskGroupWithError(selectedTodoIds: [3399, 3398])
                print("리스폰스: \(response)")
            } catch {
                self.handleError(error)
            }
        }

    }
    
    fileprivate func handleError(_ err: Error) {
        if err is TodosAPI.ApiError {
            let apiError = err as! TodosAPI.ApiError
            switch apiError {
            case .notAllowedUrl:
                print("배드유알엘")
            case .noContent:
                print("컨텐츠 없음")
            case .decodingError:
                print("디코딩 안 됨")
            case .unauthorized:
                print("인증 안 됨")
            case .badStatus(code: let code):
                print("배드 스테이터스 - 코드: \(code)")
            case .unknown(let error):
                print("알 수 없음: \(error)")
            case .jsonEncoding:
                print("JSON 인코딩 안 됨")
            }
        }
    }
}
