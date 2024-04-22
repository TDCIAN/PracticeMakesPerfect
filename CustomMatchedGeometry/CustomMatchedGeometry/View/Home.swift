//
//  Home.swift
//  CustomMatchedGeometry
//
//  Created by 김정민 on 2023/09/06.
//

import SwiftUI

struct Home: View {
    @State private var selectedProfile: Profile?
    @State private var showProfileView: Bool = false
    
    @Environment(WindowSharedModel.self) private var windowSharedModel
    @Environment(SceneDelegate.self) private var sceneDelegate
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                ForEach(profiles) { profile in
                    HStack(spacing: 12) {
                        /// to Find View's Position
                        GeometryReader(content: { geometry in
                            let rect = geometry.frame(in: .global)
                            
                            Image(profile.profilePicture)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: rect.width, height: rect.height)
                                .clipShape(.circle)
                                .contentShape(.circle)
                                .opacity(self.windowSharedModel.selectedProfile?.id == profile.id ? (self.windowSharedModel.hideNativeView || self.showProfileView ? 0 : 1) : 1)
                                .onTapGesture {
                                    Task {
                                        /// Opening Profile
                                        self.selectedProfile = profile
                                        self.windowSharedModel.selectedProfile = profile
                                        self.windowSharedModel.cornerRadius = rect.width / 2
                                        self.windowSharedModel.sourceRect = rect
                                        /// Storing the Source Rect for Closing Animation
                                        self.windowSharedModel.previousSourceRect = rect
                                        
                                        try? await Task.sleep(for: .seconds(0))
                                        self.windowSharedModel.hideNativeView = true
                                        self.showProfileView.toggle()
                                        
                                        /// After Animation Finished, Removing Hero View
                                        try? await Task.sleep(for: .seconds(0.5))
                                        if self.windowSharedModel.hideNativeView {
                                            self.windowSharedModel.hideNativeView = false
                                        }
                                        /*
                                         So what's happening here is that when an user profile is tapped,
                                         I will store the profile image position in the shared model and hide the native view,
                                         so the overlay window will show the hero view, and it will animate to the destination image position.
                                         Once the animation is finished, the hero view will be removed.
                                         Thus creating a hero animation effect.
                                         */
                                    }
                                }
                        })
                        .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(profile.userName)
                                .fontWeight(.bold)
                            
                            Text(profile.lastMsg)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(profile.lastActive)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(15)
            .padding(.horizontal, 5)
        }
        .scrollIndicators(.hidden)
        .sheet(isPresented: self.$showProfileView, content: {
            DetailProfileView(
                showProfileView: self.$showProfileView,
                selectedProfile: self.$selectedProfile
            )
            .presentationDetents([.medium, .large])
            .presentationCornerRadius(25)
            .interactiveDismissDisabled()
            .presentationDragIndicator(.hidden)
            /*
             In order to achive the complete hero effect on sheets,
             we need to disable the interactive dismiss method.
             Thus, we have to maintain a manual close button.
             */
        })
        /// Adding Hero Overlay Window For Performing Hero Animation's
        .onAppear(perform: {
            guard self.sceneDelegate.heroWindow == nil else { return }
            self.sceneDelegate.addHeroWindow(self.windowSharedModel)
        })
    }
}

#Preview {
    ContentView()
}
