//
//  DetailProfileView.swift
//  CustomMatchedGeometry
//
//  Created by 김정민 on 2023/09/06.
//

import SwiftUI

/// Detail Profile View
struct DetailProfileView: View {
    @Binding var showProfileView: Bool
    @Binding var selectedProfile: Profile?
    /// Color Scheme
    @Environment(\.colorScheme) private var scheme
    @Environment(WindowSharedModel.self) private var windowSharedModel
    
    var body: some View {
        VStack {
            GeometryReader(content: { geometry in
                let size = geometry.size
                let rect = geometry.frame(in: .global)
                
                if let selectedProfile {
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .overlay {
                            let color = self.scheme == .dark ? Color.black : Color.white
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .clear,
                                    .clear,
                                    color.opacity(0.1),
                                    color.opacity(0.5),
                                    color.opacity(0.9),
                                    color
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .clipped()
                        .opacity(self.windowSharedModel.hideNativeView ? 0 : 1)
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: { value in
                            if self.showProfileView {
                                self.windowSharedModel.sourceRect = value
                                /// Show Gradient
                                self.windowSharedModel.showGradient = true
                            }
                        })
                    
                }
            })
            .frame(maxHeight: 330)
            .overlay(alignment: .topLeading) {
                Button(action: {
                    /// Closing the Same Way as Opening
                    Task {
                        self.windowSharedModel.hideNativeView = true
                        self.showProfileView = false
                        try? await Task.sleep(for: .seconds(0))
                        /// Using the Stored Source Frame Rect to Reposition to it's original place
                        self.windowSharedModel.sourceRect = self.windowSharedModel.previousSourceRect
                        self.windowSharedModel.showGradient = false
                        /// Wating for animation completion
                        try? await Task.sleep(for: .seconds(0.5))
                        if self.windowSharedModel.hideNativeView {
                            self.windowSharedModel.reset()
                            self.selectedProfile = nil
                        }
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .contentShape(.rect)
                        .padding(10)
                        .background(.black, in: .circle)
                })
                .padding([.leading, .top], 20)
                .scaleEffect(0.9)
                .opacity(self.windowSharedModel.hideNativeView ? 0 : 1)
                .animation(.snappy, value: self.windowSharedModel.hideNativeView)
            }
            
            
            
            Spacer()
            
            
        }
    }
    
}

/// Preference Key to Read View Bounds
struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
