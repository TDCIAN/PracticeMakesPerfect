//
//  ExploreViewModel.swift
//  AirbnbSwiftUI
//
//  Created by 김정민 on 10/19/24.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var searchLocation = ""
    
    private let service: ExploreService
    private var listingsCopy = [Listing]()
    
    init(service: ExploreService) {
        self.service = service
        
        Task {
            await self.fetchListings()
        }
    }
    
    @MainActor
    func fetchListings() async {
        do {
            self.listings = try await self.service.fetchListings()
            self.listingsCopy = self.listings
        } catch {
            print("### ExploreViewModel - failed to fetch listings with error: \(error.localizedDescription)")
        }
    }
    
    func updateListingsForLocation() {
        let filteredListings = self.listings.filter({
            $0.city.lowercased() == self.searchLocation.lowercased() ||
            $0.state.lowercased() == self.searchLocation.lowercased()
        })
        print("### 업데이트 리스팅 포 로케이션 - 서치 로케이션: \(self.searchLocation)")
        self.listings = filteredListings.isEmpty ? self.listingsCopy : filteredListings
    }
}
