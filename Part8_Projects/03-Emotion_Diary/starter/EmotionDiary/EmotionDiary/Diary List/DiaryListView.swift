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

extension DiaryListView {
    private func formattedSectionTitle(_ id: String) -> String {
        let dateComponents = id
            .components(separatedBy: "-")
            .compactMap { Int($0) }
        guard let year = dateComponents.first,
              let month = dateComponents.last else {
                  return id
              }
        let calendar = Calendar(identifier: .gregorian)
        let dateComponent = DateComponents(calendar: calendar, year: year, month: month)
        let date = dateComponent.date!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}
