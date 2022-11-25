//
//  StockDetailView.swift
//  StockRank-SwiftUI
//
//  Created by joonwon lee on 2022/06/06.
//

import SwiftUI

struct StockDetailView: View {
    @ObservedObject var vm: StockRankViewModel
    @Binding var stock: StockModel
    
    var body: some View {
        VStack(spacing: 40) {
            Text("# of My Favorites: \(vm.numOfFavorite)")
                .font(.system(size: 20, weight: .bold, design: .default))
            Image(stock.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:120, height: 120)
            Text(stock.name)
                .font(.system(size: 30, weight: .bold))
            Text("\(stock.price) 원")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(stock.diff > 0 ? .red : .blue)
            
            Button {
                stock.isFavorite.toggle()                
            } label: {
                Image(systemName: "heart.fill")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(stock.isFavorite ? .red : .gray)
            }
        }
    }
}
