//
//  TodoAppTutorialApp.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/13.
//

import SwiftUI

@main
struct TodoAppTutorialApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("SwiftUI")
                    }
                
                MainVC
                    .instantiate()
                    .getRepresentable()
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("UIKit")
                    }
            }
        }
    }
}
