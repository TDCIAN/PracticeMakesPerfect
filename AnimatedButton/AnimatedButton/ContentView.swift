//
//  ContentView.swift
//  AnimatedButton
//
//  Created by 김정민 on 2023/09/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomButton(buttonTint: .blue) {
            HStack(spacing: 10) {
                Text("Login")
                Image(systemName: "chevron.right")
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
        } action: {
            try? await Task.sleep(for: .seconds(2))
            return .failed("Password Incorrect!")
//            return .success
        }
        .buttonStyle(.opacityLess)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
