//
//  View+Extension.swift
//  TabBarSheet
//
//  Created by 김정민 on 2023/09/08.
//

import SwiftUI

/// Custom View Modifiers
extension View {
    @ViewBuilder
    func hideNativeTabBar() -> some View {
        self
            .toolbar(.hidden, for: .tabBar)
    }
}

/// Custom TabView Modifiers
extension TabView {
    @ViewBuilder
    func tabSheet<SheetContent: View>(
        initialHeight: CGFloat = 100,
        sheetCornerRadius: CGFloat = 15,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        self
            .modifier(
                BottomSheetModifier(
                    initialHeight: initialHeight,
                    sheetCornerRadius: sheetCornerRadius,
                    sheetView: content()
                )
            )
    }
}

/// Helper View Modifier
fileprivate struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    var initialHeight: CGFloat
    var sheetCornerRadius: CGFloat
    var sheetView: SheetContent
    /// View Properties
    @State private var showSheet: Bool = true
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: self.$showSheet, content: {
                VStack(spacing: 0) {
                    self.sheetView
                        .background(.regularMaterial)
                        .zIndex(0)
                    
                    Divider()
                        .hidden()
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 55) // Tab Bar Height
                }
                .presentationDetents([.height(self.initialHeight), .medium, .fraction(0.99)])
                .presentationCornerRadius(self.sheetCornerRadius)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .presentationBackground(.background)
                .interactiveDismissDisabled()
            })
    }
}
