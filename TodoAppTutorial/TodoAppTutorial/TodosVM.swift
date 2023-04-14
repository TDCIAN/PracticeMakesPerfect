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
        TodosAPI.fetchTodos { result in
            switch result {
            case .success(let todosResponse):
                print(#fileID, #function, #line, "- vm success: \(todosResponse)")
            case .failure(let error):                
                print(#fileID, #function, #line, "- vm error: \(error)")
            }
        }
    }
    
}
