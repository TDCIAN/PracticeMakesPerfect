//
//  ContentView.swift
//  CryptoAsyncAwait
//
//  Created by 김정민 on 5/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(self.viewModel.coins) { coin in
                    CoinRowView(coin: coin)
                        .onAppear {
                            if coin.id == self.viewModel.coins.last?.id {
                                print("DEBUG: Paginate here..")
                                self.viewModel.loadData()
                            }
                        }
                }
            }
            .refreshable {
                self.viewModel.handleRefresh()
            }
            .onReceive(self.viewModel.$error, perform: { error in
                if error != nil {
                    self.showAlert.toggle()
                }
            })
            .alert(isPresented: self.$showAlert, content: {
                Alert(
                    title: Text("error"),
                    message: Text(self.viewModel.error?.localizedDescription ?? "")
                )
            })
            .navigationTitle("Live Prices")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
