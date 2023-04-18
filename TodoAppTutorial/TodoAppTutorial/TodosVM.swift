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

        TodosAPI.deleteATodo(id: 3387) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let todo):
                print(#fileID, #function, #line, "- 석세스 todo: \(todo)")
            case .failure(let error):
                print(#fileID, #function, #line, "- 에러 error: \(error)")
                self.handleError(error)
            }
        }
        
//        TodosAPI.editTodo(id: 3388, title: "풋수정 해보겠습니다", isDone: true) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let todo):
//                print(#fileID, #function, #line, "- 석세스 todo: \(todo)")
//            case .failure(let error):
//                print(#fileID, #function, #line, "- 에러 error: \(error)")
//                self.handleError(error)
//            }
//        }
        
//        TodosAPI.editTodoJson(id: 3388, title: "수정 한 번 해보겠습니다", isDone: true) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let todo):
//                print(#fileID, #function, #line, "- 석세스 todo: \(todo)")
//            case .failure(let error):
//                print(#fileID, #function, #line, "- 에러 error: \(error)")
//                self.handleError(error)
//            }
//        }
        
//        TodosAPI.addATodoJson(title: "JSON으로 추가 해보겠습니다", isDone: false) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let todo):
//                print(#fileID, #function, #line, "- 석세스 todo: \(todo)")
//            case .failure(let error):
//                print(#fileID, #function, #line, "- 에러 error: \(error)")
//                self.handleError(error)
//            }
//        }
        
//        TodosAPI.searchTodos(searchTerm: "빡코") { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let todosResponse):
//                print(#fileID, #function, #line, "- vm success: \(todosResponse)")
//            case .failure(let error):
//                print(#fileID, #function, #line, "- vm error: \(error)")
//                self.handleError(error)
//            }
//        }
        
//        TodosAPI.fetchATodo(id: 9999) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let todo):
//                print(#fileID, #function, #line, "- todo: \(todo)")
//            case .failure(let error):
//                print(#fileID, #function, #line, "- error: \(error)")
//                self.handleError(error)
//            }
//        }
        
//        TodosAPI.fetchTodos { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let todosResponse):
//                print(#fileID, #function, #line, "- vm success: \(todosResponse)")
//            case .failure(let error):
//                print(#fileID, #function, #line, "- vm error: \(error)")
//                self.handleError(error)
//            }
//        }
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
            case .jsonEncodingError:
                print("JSON 인코딩 안 됨")
            }
        }
    }
}
