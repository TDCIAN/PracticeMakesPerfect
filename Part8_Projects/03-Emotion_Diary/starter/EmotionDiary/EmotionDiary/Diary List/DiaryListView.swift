//
//  ContentView.swift
//  EmotionDiary
//
//  Created by joonwon lee on 2022/07/02.
//

import SwiftUI

struct DiaryListView: View {
    
    @StateObject var vm: DiaryListViewModel
    
    let layout: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {        
        LazyVGrid(columns: layout) {
            ForEach(vm.keys, id: \.self) { key in
                Section {
                    let items = vm.dic[key] ?? []
                    let orderedItems = items.sorted { $0.date < $1.date }
                    
                    ForEach(orderedItems) { item in
                        MoodDiaryCell(diary: item)
                            .frame(height: 50)
                    }
                } header: {
                    Text(key)
                }
                
            }
            .onAppear {
                print("앱 켜짐")
            }
        }
    }
}
