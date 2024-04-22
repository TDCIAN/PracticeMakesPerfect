//
//  TabBarSheetApp.swift
//  TabBarSheet
//
//  Created by 김정민 on 2023/09/08.
//

import SwiftUI

@main
struct TabBarSheetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    var windowSharedModel = WindowSharedModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(self.windowSharedModel)
        }
    }
}

/// App Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}

/// Scene Delegate
@Observable
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    weak var windowScene: UIWindowScene?
    var tabWindow: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.windowScene = scene as? UIWindowScene
    }
    
    /// Adding Tab Bar as an another Window
    func addTabBar(_ windowSharedModel: WindowSharedModel) {
        guard let scene = self.windowScene else { return }
        
        let tabBarController = UIHostingController(
            rootView: 
                CustomTabBar()
                .environment(windowSharedModel)
                .frame(maxHeight: .infinity, alignment: .bottom)
        )
        tabBarController.view.backgroundColor = .clear
        /// Window
        let tabWindow = PassThroughWindow(windowScene: scene)
        tabWindow.rootViewController = tabBarController
        tabWindow.isHidden = false
        /// Storing TabWindow Reference, For Future Use
        self.tabWindow = tabWindow
    }
}

/// PassTrough UIWindow
class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}
