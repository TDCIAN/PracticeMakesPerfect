//
//  Memo.swift
//  MyTodoApp
//
//  Created by JeongminKim on 2023/05/01.
//

import UIKit

struct Memo: Hashable {
    var uuid: UUID = UUID()
    var isDone: Bool
    var content: String
    
    init(isDone: Bool = false, content: String = "") {
        self.isDone = isDone
        self.content = content
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
