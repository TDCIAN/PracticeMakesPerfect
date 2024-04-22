//
//  ContentView.swift
//  SwipeToHideNavBar
//
//  Created by 김정민 on 2023/09/10.
//

import SwiftUI

struct ContentView: View {
    @State private var hideNavBar: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(1...50, id: \.self) { index in
                    NavigationLink {
                        List {
                            ForEach(1...50, id: \.self) { index in
                                Text("Sub Item: \(index)")
                            }
                        }
                    } label: {
                        Text("List Item \(index)")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Chat App")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.hideNavBar.toggle()
                    }, label: {
                        Image(systemName: self.hideNavBar ? "eye.slash" : "eye")
                    })
                }
            })
            .hideNavBarOnSwipe(self.hideNavBar)
        }
    }
}

#Preview {
    ContentView()
}
