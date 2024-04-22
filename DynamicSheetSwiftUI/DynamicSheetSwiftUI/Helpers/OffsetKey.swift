//
//  OffsetKey.swift
//  DynamicSheetSwiftUI
//
//  Created by 김정민 on 2023/09/18.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
