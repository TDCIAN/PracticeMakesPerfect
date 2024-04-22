//
//  CustomMatchedGeometryApp.swift
//  CustomMatchedGeometry
//
//  Created by 김정민 on 2023/09/06.
//

import SwiftUI

@main
struct CustomMatchedGeometryApp: App {
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
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        /// Connection Scene Delegate
        config.delegateClass = SceneDelegate.self
        return config
    }
}

/// Scene Delegate
@Observable
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    weak var windowScene: UIWindowScene?
    
    /// Hero Overlay Window
    var heroWindow: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.windowScene = scene as? UIWindowScene
    }
    
    /// Adding Hero Window to the Scene
    func addHeroWindow(_ windowSharedModel: WindowSharedModel) {
        guard let scene = self.windowScene else { return }
        
        let heroViewController = UIHostingController(
            rootView:
                CustomHeroAnimationView()
                .environment(windowSharedModel)
                /// Since We Don't Need Any Interaction
                .allowsHitTesting(false)
        )
        heroViewController.view.backgroundColor = .clear
        let heroWindow = UIWindow(windowScene: scene)
        heroWindow.rootViewController = heroViewController
        heroWindow.isHidden = false
        heroWindow.isUserInteractionEnabled = false // We don't need any pass-through windows to interact with the main window since we completely disabled the interaction for the overlay window.
        /// Storing Window Reference
        self.heroWindow = heroWindow
    }
}
