//
//  ContentView.swift
//  CustomUniversalAlertSwiftUI
//
//  Created by 김정민 on 2023/09/19.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var alert: AlertConfig = .init()
    @State private var alert1: AlertConfig = .init(slideEdge: .top)
    @State private var alert2: AlertConfig = .init(slideEdge: .leading)
    @State private var alert3: AlertConfig = .init(disableOutsideTap: false, slideEdge: .trailing)
    
    var body: some View {
        Button(action: {
            self.alert.present()
            self.alert1.present()
            self.alert2.present()
            self.alert3.present()
        }, label: {
            Text("Show Alert")
        })
        .alert(alertConfig: self.$alert) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.red.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    self.alert.dismiss()
                }
        }
        .alert(alertConfig: self.$alert1) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.blue.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    self.alert1.dismiss()
                }
        }
        .alert(alertConfig: self.$alert2) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.yellow.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    self.alert2.dismiss()
                }
        }
        .alert(alertConfig: self.$alert3) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.green.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    self.alert3.dismiss()
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(SceneDelegate())
}
