//
//  ExploreView.swift
//  AirbnbSwiftUI
//
//  Created by 김정민 on 10/16/24.
//

import SwiftUI

struct ExploreView: View {
    
    @State private var showDestinationSearchView: Bool = false
    @StateObject var viewModel = ExploreViewModel(service: ExploreService())
    
    var body: some View {
        NavigationStack {
//        NavigationView { -> NavigationView에서는 NavigationLink(value) 작동 안됨
            
            if self.showDestinationSearchView {
                DestinationSearchView(
                    show: self.$showDestinationSearchView,
                    viewModel: self.viewModel
                )
            } else {
                VStack {
                    ScrollView {
                        SearchAndFilterBar(location: self.$viewModel.searchLocation)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    self.showDestinationSearchView.toggle()
                                }
                            }
                        
                        LazyVStack(spacing: 32) {
                            ForEach(self.viewModel.listings, id: \.self) { listing in
                                NavigationLink(value: listing) {
                                    ListingItemView(listing: listing)
                                        .frame(height: 400)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationDestination(for: Listing.self) { listing in
                        ListingDetailView(listing: listing)
                            .toolbar(.hidden)
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
