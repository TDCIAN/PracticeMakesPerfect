//
//  TodosView.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/13.
//

import SwiftUI

struct TodosView: View {
    var body: some View {
        VStack(alignment: .leading) {
            getHeader()
            
            UISearchBarWrapper()
            
            Spacer()
            
            List {
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
            }
            .listStyle(.plain)
        }
    }
    
    fileprivate func getHeader() -> some View {
        Group {
            topHeader
            
            secondHeader
        }.padding(.horizontal, 10)
    }
    
    fileprivate var topHeader: some View {
        Group {
            Text("TodosView / page: 0")
            Text("선택된 할일: []")
            
            HStack {
                Button {
                    
                } label: {
                    Text("클로저")
                }.buttonStyle(MyDefaultButtonStyle())
                
                Button {
                    
                } label: {
                    Text("Rx")
                }.buttonStyle(MyDefaultButtonStyle())
                
                Button {
                    
                } label: {
                    Text("콤바인")
                }.buttonStyle(MyDefaultButtonStyle())
                
                Button {
                    
                } label: {
                    Text("Async")
                }.buttonStyle(MyDefaultButtonStyle())
                
            }
        }
    }
    
    fileprivate var secondHeader: some View {
        Group {
            Text("Async 변환 액션들")
            
            HStack {
                Button {
                    
                } label: {
                    Text("클로저 👉 Async")
                }.buttonStyle(MyDefaultButtonStyle())
                
                Button {
                    
                } label: {
                    Text("Rx 👉 Async")
                }.buttonStyle(MyDefaultButtonStyle())
                
                Button {
                    
                } label: {
                    Text("콤바인 👉 Async")
                }.buttonStyle(MyDefaultButtonStyle())
            }
            
            HStack {
                Button {
                    
                } label: {
                    Text("초기화")
                }.buttonStyle(MyDefaultButtonStyle(bgColor: .purple))
                
                Button {
                    
                } label: {
                    Text("선택된 할일들 삭제")
                }.buttonStyle(MyDefaultButtonStyle(bgColor: .black))
                
                Button {
                    
                } label: {
                    Text("할 일 추가")
                }.buttonStyle(MyDefaultButtonStyle(bgColor: .gray))
            }
        }
    }
}

struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        TodosView()
    }
}
