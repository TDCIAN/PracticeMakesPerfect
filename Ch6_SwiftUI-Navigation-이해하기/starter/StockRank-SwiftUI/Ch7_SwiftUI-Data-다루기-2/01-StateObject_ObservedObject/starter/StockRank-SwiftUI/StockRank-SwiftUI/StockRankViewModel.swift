//
//  StockRankViewModel.swift
//  StockRank-SwiftUI
//
//  Created by JeongminKim on 2022/11/24.
//

import Foundation

final class StockRankViewModel: ObservableObject {
    @Published var models: [StockModel] = StockModel.list
    
    var numOfFavorite: Int {
        let count = models.filter { $0.isFavorite }.count
        return count
    }
}
