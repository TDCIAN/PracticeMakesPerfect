//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/13.
//

import Foundation
import Combine

class TodosVM: ObservableObject {
    
    init() {        
        print(#fileID, #function, #line, "- ")
        TodosAPI.fetchTodos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let todosResponse):
                print(#fileID, #function, #line, "- vm success: \(todosResponse)")
            case .failure(let error):                
                print(#fileID, #function, #line, "- vm error: \(error)")
                self.handleError(error)
            }
        }
    }
    
    fileprivate func handleError(_ err: Error) {
        if err is TodosAPI.ApiError {
            let apiError = err as! TodosAPI.ApiError
            switch apiError {
            case .badUrl:
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
            }
        }
    }
}
