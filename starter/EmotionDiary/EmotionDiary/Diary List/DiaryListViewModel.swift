//
//  DiaryListViewModel.swift
//  EmotionDiary
//
//  Created by JeongminKim on 2023/03/07.
//

import Foundation

final class DiaryListViewModel: ObservableObject {
    @Published var list: [MoodDiary] = MoodDiary.list
    @Published var dic: [String: [MoodDiary]] = [:]
    
    var keys: [String] {
        return dic.keys.sorted { $0 < $1 }
    }
    
    init() {
        self.dic = Dictionary(
            grouping: self.list,
            by: { $0.monthlyIdentifier }
        )
    }
}
