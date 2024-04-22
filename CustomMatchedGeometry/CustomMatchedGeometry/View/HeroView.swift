//
//  HeroView.swift
//  CustomMatchedGeometry
//
//  Created by 김정민 on 2023/09/06.
//

import SwiftUI

struct CustomHeroAnimationView: View {
    @Environment(WindowSharedModel.self) private var windowSharedModel
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                let sourceRect = self.windowSharedModel.sourceRect
                if let selectedProfile = self.windowSharedModel.selectedProfile,
                   self.windowSharedModel.hideNativeView {
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: sourceRect.width, height: sourceRect.height)
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
                            .opacity(self.windowSharedModel.showGradient ? 1 : 0)
                        }
                        .clipShape(.rect(cornerRadius: self.windowSharedModel.cornerRadius))
                        .offset(x: sourceRect.minX, y: sourceRect.minY)
                        .animation(.snappy(duration: 0.3, extraBounce: 0), value: self.windowSharedModel.showGradient)
                }
            }
            /// Animating Frame Changes
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: self.windowSharedModel.sourceRect) // Since I will be removing the hero view after 0.5 seconds, I'm setting a suitable duration to complete the animation within those seconds.
            .ignoresSafeArea()
        })
    }
}

