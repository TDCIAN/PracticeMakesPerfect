//
//  ContentView.swift
//  TabBarSheet
//
//  Created by 김정민 on 2023/09/08.
//

import SwiftUI
import MapKit

extension MKCoordinateRegion {
    /// Apple Park Location Coordinates
    static var applePark: MKCoordinateRegion {
        return .init(
            center: .init(latitude: 37.3346, longitude: -122.0090),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }
}

struct ContentView: View {
    @Environment(WindowSharedModel.self) private var windowSharedModel
    @Environment(SceneDelegate.self) private var sceneDelegate
    
    var body: some View {
        @Bindable var bindableObject = self.windowSharedModel
        
        TabView(selection: $bindableObject.activeTab) {
            NavigationStack {
                Text("People")
            }
            .tag(Tab.people)
            .hideNativeTabBar()
            
            NavigationStack {
                Map(initialPosition: .region(.applePark))
            }
            .tag(Tab.devices)
            .hideNativeTabBar()
            
            NavigationStack {
                Text("Items")
            }
            .tag(Tab.items)
            .hideNativeTabBar()
            
            NavigationStack {
                Text("Me")
            }
            .tag(Tab.me)
            .hideNativeTabBar()
        }
        .tabSheet(initialHeight: 110, sheetCornerRadius: 15) {
            NavigationStack {
                ScrollView {
                    /// Showing Some Sample Mock Devices
                    VStack(spacing: 15) {
                        if self.windowSharedModel.activeTab == .devices {
                            DeviceRowView("iphone", "iJustine's iPhone", "Home")
                            DeviceRowView("ipad", "iJustine's iPad", "Home")
                            DeviceRowView("applewatch", "iJustine's Watch Ultra", "Home")
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                }
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .toolbar(content: {
                    /// Leading Title
                    ToolbarItem(placement: .topBarLeading) {
                        Text(self.windowSharedModel.activeTab.title)
                            .font(.title3.bold())
                    }
                    
                    /// Showing Plus Button for only Devices
                    if self.windowSharedModel.activeTab == .devices {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "plus")
                            })
                        }
                    }
                })
            }
        }
        .onAppear {
            guard self.sceneDelegate.tabWindow == nil else { return }
            self.sceneDelegate.addTabBar(self.windowSharedModel)
        }
    }
    
    /// Device Row View
    @ViewBuilder
    func DeviceRowView(_ image: String, _ title: String, _ subTitle: String) -> some View {
        VStack(spacing: 0) {
            Divider()
        
            HStack(spacing: 12) {
                Image(systemName: image)
                    .font(.title2)
                    .padding(12)
                    .background(.background, in: .circle)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .fontWeight(.bold)
                    
                    Text(subTitle)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("0 km")
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
        }
        .background(.regularMaterial)
    }
}

/// Custom Tab Bar
struct CustomTabBar: View {
    @Environment(WindowSharedModel.self) private var windowSharedModel
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button(action: {
                        self.windowSharedModel.activeTab = tab
                    }, label: {
                        VStack {
                            Image(systemName: tab.rawValue)
                                .font(.title2)
                            
                            Text(tab.title)
                                .font(.caption)
                        }
                        .foregroundColor(self.windowSharedModel.activeTab == tab ? Color.accentColor : .gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(.rect)
                    })
                }
            }
            .frame(height: 55)
        }
        .background(.regularMaterial)
    }
}
