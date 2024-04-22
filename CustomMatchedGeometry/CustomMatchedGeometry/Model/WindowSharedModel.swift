//
//  WindowSharedModel.swift
//  CustomMatchedGeometry
//
//  Created by 김정민 on 2023/09/06.
//

import SwiftUI

@Observable
class WindowSharedModel {
    var sourceRect: CGRect = .zero
    var previousSourceRect: CGRect = .zero
    var hideNativeView: Bool = false
    var selectedProfile: Profile?
    var cornerRadius: CGFloat = 0
    var showGradient: Bool = false
    
    /// Resetting Properties
    func reset() {
        self.sourceRect = .zero
        self.previousSourceRect = .zero
        self.hideNativeView = false
        self.selectedProfile = nil
        self.cornerRadius = 0
        self.showGradient = false
    }
}
/*
 6:47
 I'm going to use multiple windows to achieve this custom hero effect,
 so this model will be shared between windows.
 I've aleardy done a video about placing tab bars over sheets using the same concept,
 I will attach video link in the description. Check it out.
 -> SwiftUI: Placing Tab Bar Over Sheet's(https://www.youtube.com/watch?v=8Ys83qvnDvE&ab_channel=Kavsoft)
 
 Also, FiveStar Blog has an excellent blog about this multiple window concept.
 I will pin the link in the comment.
 -> Five Stars Blog(https://www.fivestars.blog/articles/swiftui-windows/)
 */
