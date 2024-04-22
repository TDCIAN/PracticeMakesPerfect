//
//  Navigation+Extension.swift
//  SwipeToHideNavBar
//
//  Created by 김정민 on 2023/09/10.
//

import SwiftUI

/// Custom View Modifier
extension View {
    @ViewBuilder
    func hideNavBarOnSwipe(_ isHidden: Bool) -> some View {
        self
            .modifier(NavBarModifier(isHidden: isHidden))
    }
}

private struct NavBarModifier: ViewModifier {
    var isHidden: Bool
    @State private var isNavBarHidden: Bool?
    func body(content: Content) -> some View {
        content
            .onChange(of: self.isHidden, initial: true, { oldValue, newValue in
                self.isNavBarHidden = newValue
            })
            .onDisappear(perform: {
                self.isNavBarHidden = nil
                /*
                 Video time: (05:52 / 06:22)
                 Why does this variable need to be set to nil?
                 Because when the view appears once again, the status won't be updated since there is no change in the value.
                 Thus, when we set the value to nil when the view disappears, it will be set to a non-nil value once the view appears,
                 and thus it will update the navigation bar status.
                 */
            })
            .background(NavigationControllerExtractor(isHidden: self.isNavBarHidden))
    }
}

/// Extracting UINavigationController from SwiftUI View
private struct NavigationControllerExtractor: UIViewRepresentable {
    var isHidden: Bool?
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            /*
             Video time: (03:06 / 06:22)
             What I'm going to do is extract the associated root UIViewController from the UIView with a custom extension.
             The associated view controller will hold the UINavigationController, and with that, we can make customizations.
             */
            if let hostView = uiView.superview,
               let parentController = hostView.parentController {
                if let isHidden {
                    parentController.navigationController?.hidesBarsOnSwipe = isHidden
                }
            }
            
        }
    }
}

private extension UIView {
    var parentController: UIViewController? {
        sequence(first: self) { view in
            view.next
        }
        .first { responder in
            return responder is UIViewController
        } as? UIViewController
    }
}
