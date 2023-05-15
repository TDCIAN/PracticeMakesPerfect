//
//  TCA_TutorialApp.swift
//  TCA_Tutorial
//
//  Created by JeongminKim on 2023/05/13.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_TutorialApp: App {
    
    let counterStore = Store(
        initialState: CounterState(),
        reducer: counterReducer,
        environment: CounterEnvironment()
    )
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: counterStore)
        }
    }
}
