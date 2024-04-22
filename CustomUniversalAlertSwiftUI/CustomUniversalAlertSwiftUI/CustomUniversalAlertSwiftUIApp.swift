//
//  CustomUniversalAlertSwiftUIApp.swift
//  CustomUniversalAlertSwiftUI
//
//  Created by 김정민 on 2023/09/19.
//

import SwiftUI

@main
struct CustomUniversalAlertSwiftUIApp: App {
    /*
     Video Time: (03:35 / 17:58)
     - Connecting the Scene Delegate to the SwiftUI Life-Cycle via the Delegate Adaptor
     */
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
