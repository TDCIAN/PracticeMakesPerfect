//
//  UniversalAlert.swift
//  CustomUniversalAlertSwiftUI
//
//  Created by 김정민 on 2023/09/19.
//

import SwiftUI

/// Alert Config
struct AlertConfig {
    fileprivate var enableBackgroundBlur: Bool = true
    fileprivate var disableOutsideTap: Bool = true
    fileprivate var transitionType: TransitionType = .slide
    fileprivate var slideEdge: Edge = .bottom
    fileprivate var show: Bool = false
    fileprivate var showView: Bool = false
    
    init(enableBackgroundBlur: Bool = true, disableOutsideTap: Bool = true, transitionType: TransitionType = .slide, slideEdge: Edge = .bottom) {
        self.enableBackgroundBlur = enableBackgroundBlur
        self.disableOutsideTap = disableOutsideTap
        self.transitionType = transitionType
        self.slideEdge = slideEdge
    }
    
    /// TransitionType
    enum TransitionType {
        case slide
        case opacity
    }
    
    /// Alert Present / Dismiss Methods
    mutating func present() {
        self.show = true
    }
    
    mutating func dismiss() {
        self.show = false
    }
}

/// App Delegate
@Observable
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        /// Setting SceneDelegate Class
        config.delegateClass = SceneDelegate.self
        return config
    }
}

/// Scene Delegate
/*
 Video Time: (02:14 / 17:58)
 - The reason for the use of observable is that this will automatically inject this object as an Environment Object in our SwiftUI Lifecycle,
 and then we can use it directly inside our SwiftUI Views.
 */
@Observable
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    /// Current Scene
    weak var windowScene: UIWindowScene?
    var overlayWindow: UIWindow?
    var tag: Int = 0
    var alerts: [UIView] = []
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.windowScene = scene as? UIWindowScene
        self.setupOverlayWindow()
    }
    
    /// Adding Overlay Window To Handle All our Alerts on the Top of the Current Window
    private func setupOverlayWindow() {
        guard let windowScene = self.windowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.isHidden = true
        window.isUserInteractionEnabled = false
        self.overlayWindow = window
    }
    
    /*
     Video Time: (04:27 / 17:58)
     - The ViewTag closure will return the appropriate tag for the added alert view, and with that, we can remove the alert in some complex cases(as shown in the video).
     */
    fileprivate func alert<Content: View>(config: Binding<AlertConfig>, @ViewBuilder content: @escaping () -> Content, viewTag: @escaping (Int) -> ()) {
        guard let alertWindow = self.overlayWindow else { return }
        
        let viewController = UIHostingController(
            rootView:
                AlertView(config: config, tag: self.tag, content: {
                    content()
                })
        )
        viewController.view.backgroundColor = .clear
        viewController.view.tag = self.tag
        self.tag += 1 // Since each tag must be unique for each view, it's incremented for each alert.
        
        if alertWindow.rootViewController == nil {
            alertWindow.rootViewController = viewController
            alertWindow.isHidden = false
            alertWindow.isUserInteractionEnabled = true
        } else {
            viewController.view.frame = alertWindow.rootViewController?.view.frame ?? .zero
            alerts.append(viewController.view)
        }
    }
}

/// Custom View Extensions
extension View {
    @ViewBuilder
    func alert<Content: View>(alertConfig: Binding<AlertConfig>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .modifier(AlertModifier(config: alertConfig, alertContent: content))
    }
}

/// Alert Handling View Modifier
fileprivate struct AlertModifier<AlertContent: View>: ViewModifier {
    @Binding var config: AlertConfig
    @ViewBuilder var alertContent: () -> AlertContent
    /// Scene Delegate
    @Environment(SceneDelegate.self) private var sceneDelegate
    /// View Tag
    @State private var viewTag: Int = 0
    
    func body(content: Content) -> some View {
        content
            .onChange(of: self.config.show, initial: false) { oldValue, newValue in
                if newValue {
                    /// Simply Call the Function we implemented on SceneDelegate
                    self.sceneDelegate.alert(config: self.$config, content: self.alertContent) { tag in
                        self.viewTag = tag
                    }
                } else {
                    guard let alertWindow = self.sceneDelegate.overlayWindow else { return }
                    if self.config.showView {
                        withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                            self.config.showView = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            if self.sceneDelegate.alerts.isEmpty {
                                alertWindow.rootViewController = nil
                                alertWindow.isHidden = true
                                alertWindow.isUserInteractionEnabled = false
                            } else {
                                if let first = self.sceneDelegate.alerts.first {
                                    /// Presenting Next Alert
                                    /// Removing the Preview View
                                    alertWindow.rootViewController?.view.subviews.forEach({ view in
                                        view.removeFromSuperview()
                                    })
                                    
                                    alertWindow.rootViewController?.view.addSubview(first)
                                    /// Removing the Added alert from the Array
                                    self.sceneDelegate.alerts.removeFirst()
                                }
                            }
                            
                        }
                    } else {
                        print("View is not appeared")
                        /// Removing the view from the Array with the help of View Tag
                        self.sceneDelegate.alerts.removeAll(where: { $0.tag == self.viewTag })
                    }
                }
            }
    }
}

fileprivate struct AlertView<Content: View>: View {
    @Binding var config: AlertConfig
    /// View Tag
    var tag: Int
    /// View Properties
    @State private var showView: Bool = false
    @ViewBuilder var content: () -> Content
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                if self.config.enableBackgroundBlur {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.primary.opacity(0.25))
                }
            }
            .ignoresSafeArea()
            .contentShape(.rect)
            .onTapGesture {
                if !self.config.disableOutsideTap {
                    self.config.dismiss()
                }
            }
            .opacity(self.showView ? 1 : 0)
            
            if self.showView && self.config.transitionType == .slide {
                self.content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: self.config.slideEdge))
            } else {
                self.content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(self.showView ? 1 : 0)
            }
        })
        .onAppear(perform: {
            withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                self.config.showView = true
            }
        })
        .onChange(of: self.config.showView) { oldValue, newValue in
            withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                self.showView = newValue
            }
        }
    }
}
