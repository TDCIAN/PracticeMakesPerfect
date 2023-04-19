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
        
        TodosAPI.deleteSelectedTodosWithPublisherZip(selectedTodoIds: [3397, 3396, 3395, 9999, 8888])
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.handleError(error)
                case .finished:
                    print("TodosVM - finished")
                }
            } receiveValue: { response in
                print("TodosVM - response: \(response)")
            }
            .store(in: &subscriptions)



        
//        TodosAPI.addTodoAndFetchTodosWithPublisher(title: "추가추가추")
//            .sink { [weak self] completion in
//                guard let self = self else { return }
//                switch completion {
//                case .failure(let error):
//                    self.handleError(error)
//                case .finished:
//                    print("피니시드")
//                }
//            } receiveValue: { todoList in
//                print("투두리스트: \(todoList)")
//            }.store(in: &subscriptions)

            
        
        
//        TodosAPI.fetchTodosWithPublisher()
//            .sink { [weak self] completion in
//                guard let self = self else { return }
//                switch completion {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .finished:
//                    print("TodosVM - finished")
//                }
//            } receiveValue: { response in
//                print("TodosVM - response: \(response)")
//            }.store(in: &subscriptions)

        
        
//        TodosAPI.fetchTodosWithPublisherResult()
//            .sink { result in
//                switch result {
//                case .success(let todos):
//                    print("페치투두스위드퍼블리셔 리절트 - \(todos)")
//                case .failure(let error):
//                    self.handleError(error)
//                }
//            }.store(in: &subscriptions)
        
            
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
