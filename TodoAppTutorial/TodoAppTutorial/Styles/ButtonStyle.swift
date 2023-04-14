//
//  ButtonStyle.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/13.
//

import SwiftUI

struct MyDefaultButtonStyle: ButtonStyle {
    
    let textColor: Color
    let bgColor: Color
    
    init(textColor: Color = Color.white, bgColor: Color = Color.blue) {
        self.textColor = textColor
        self.bgColor = bgColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration
                .label
                .foregroundColor(textColor)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
            Spacer()
        }
        .padding()
        .background(bgColor.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
