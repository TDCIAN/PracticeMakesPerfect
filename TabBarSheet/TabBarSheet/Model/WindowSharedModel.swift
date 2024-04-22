//
//  WindowSharedModel.swift
//  TabBarSheet
//
//  Created by 김정민 on 2023/09/08.
//

import SwiftUI

@Observable
class WindowSharedModel {
    var activeTab: Tab = .devices
}
/*
 This is shared between the TabBar Window and the Main View Window.
 You can add extra properties as per your needs.
 */
