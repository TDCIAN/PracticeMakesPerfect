//
//  ListingImageCarouselView.swift
//  AirbnbSwiftUI
//
//  Created by 김정민 on 10/16/24.
//

import SwiftUI

struct ListingImageCarouselView: View {
    let listing: Listing
    
    var images = [
        "listing-1",
        "listing-2",
        "listing-3",
        "listing-4",
    ]
    
    var body: some View {
        TabView {
            ForEach(self.images, id: \.self) { image in
                Image(image)
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ListingImageCarouselView(listing: DeveloperPeview.shared.listings[0])
}
