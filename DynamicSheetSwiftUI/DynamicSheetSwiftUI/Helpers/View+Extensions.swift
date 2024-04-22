//
//  View+Extensions.swift
//  DynamicSheetSwiftUI
//
//  Created by 김정민 on 2023/09/18.
//

import SwiftUI

extension View {
    @ViewBuilder
    func heightChangePreference(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader(content: { geometry in
                    Color.clear
                        .preference(key: SizeKey.self, value: geometry.size.height)
                        .onPreferenceChange(SizeKey.self, perform: { value in
                            completion(value)
                        })
                })
            }
    }
    
    @ViewBuilder
    func minXChangePreference(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader(content: { geometry in
                    Color.clear
                        .preference(key: OffsetKey.self, value: geometry.frame(in: .scrollView).minX)
                        .onPreferenceChange(OffsetKey.self, perform: { value in
                            completion(value)
                        })
                })
            }
    }
}
