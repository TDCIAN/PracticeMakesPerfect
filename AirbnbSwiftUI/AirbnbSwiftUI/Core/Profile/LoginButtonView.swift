//
//  LoginButtonView.swift
//  AirbnbSwiftUI
//
//  Created by 김정민 on 10/18/24.
//

import SwiftUI

struct LoginButtonView: View {
    
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            print("Log in")
            self.action()
        }, label: {
            Text("Log in")
                .foregroundStyle(.white)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 360, height: 48)
                .background(.pink)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        })
    }
}

#Preview {
    LoginButtonView(action: { print("로그인 버튼 눌렀다") })
}
