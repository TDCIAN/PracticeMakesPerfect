//
//  Card.swift
//  ParallaxCarouselSwiftUI
//
//  Created by 김정민 on 2023/09/13.
//

import SwiftUI

/// Card Model
struct Card: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

/// Sample Cards
var cards: [Card] = [
    .init(title: "Dog 1", subTitle: "Cute Dog 1", image: "dog1"),
    .init(title: "Dog 2", subTitle: "Cute Dog 2", image: "dog2"),
    .init(title: "Dog 3", subTitle: "Cute Dog 3", image: "dog3"),
]
