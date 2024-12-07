//
//  ExploreService.swift
//  AirbnbSwiftUI
//
//  Created by 김정민 on 10/19/24.
//

import Foundation

class ExploreService {
    func fetchListings() async throws -> [Listing] {
        return DeveloperPeview.shared.listings
    }
}
