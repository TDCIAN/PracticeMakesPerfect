//
//  ContentView.swift
//  ContentTransitions
//
//  Created by 김정민 on 2023/09/05.
//

import SwiftUI

struct ContentView: View {
    @State private var text: Int = 0
    @State private var sfImage: String = "house.fill"
    @State private var sfCount: Int = 1
    var body: some View {
        VStack {
            Image(systemName: self.sfImage)
                .font(.largeTitle.bold())
                .contentTransition(.symbolEffect(.automatic))
                .frame(height: 50)
            
            Button(action: {
                let images: [String] = [
                    "suit.heart.fill",
                    "house.fill",
                    "gearshape",
                    "person.circle.fill",
                    "iphone",
                    "macbook"
                ]
                withAnimation(.bouncy) {
                    self.sfCount += 1
                    self.sfImage = images[self.sfCount % images.count]
                }
            }, label: {
                Text("Change Image")
            })
            .padding()
            
            Text("$\(self.text)")
                .font(.largeTitle.bold())
                .contentTransition(.numericText(value: Double(text)))
            
            Button(action: {
                withAnimation(.bouncy) {
                    self.text = .random(in: 100...1000)
                }
            }, label: {
                Text("Update")
            })
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
