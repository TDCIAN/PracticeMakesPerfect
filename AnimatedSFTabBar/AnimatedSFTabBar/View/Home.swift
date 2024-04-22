//
//  Home.swift
//  AnimatedSFTabBar
//
//  Created by 김정민 on 2023/09/03.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var activeTab: Tab = .photos
    /// All Tab's
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    
    /// Bounce Property
    @State private var bouncesDown: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: self.$activeTab) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    NavigationStack {
                        VStack {
                            
                        }
                        .navigationTitle(tab.title)
                    }
                    .setUpTab(tab)
                }
            }
            
            /// JUST FOR DEMO PURPOSE
            Picker("", selection: self.$bouncesDown) {
                Text("Bounces Down")
                    .tag(true)
                
                Text("Bounces Up")
                    .tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
            
            self.CustomTabBar()
        }
    }
    
    /// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(self.$allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(self.bouncesDown ? .bounce.down.byLayer : .bounce.up.byLayer, value: animatedTab.isAnimating)
                    
                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(self.activeTab == tab ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        self.activeTab = tab
                        animatedTab.isAnimating = true
                    }, completion: {
                        /*
                         if you don't add transaction, then animation occurs twice.
                         Because the symbolEffect modifier animates the image when the value changes. To avoid this, we can use Transaction() to tell SwiftUI to disable animation for this particular transaction.
                         */
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    })
                }
            }
            
        }
        .background(.bar) // you can use it from iOS 17
    }
}

#Preview {
    Home()
}

extension View {
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
