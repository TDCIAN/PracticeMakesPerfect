//
//  UserListViewModel.swift
//  AsyncAwaitSwiftUI
//
//  Created by 김정민 on 5/2/24.
//

import Foundation
import Combine
import RxSwift

@MainActor
final class UserListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let disposeBag = DisposeBag()
    
    @Published var users: [UserModel] = []
    @Published var isLoading: Bool = false
    @Published var shouldShowError: Bool = false
    @Published var errorMessage: String?
    
    func getUsers() async {
        self.isLoading = true
        do {
            let users = try await WebService.getUsersData()
            self.users = users
            self.isLoading = false
        } catch(let error) {
            self.isLoading = false
            self.shouldShowError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    func getUsersWithCombine() {
        self.isLoading = true
        WebService.getUsersDataWithCombine()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    self.shouldShowError = false
                case .failure(let error):
                    self.shouldShowError = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { users in
                self.users = users
            })
            .store(in: &self.cancellables)
    }
    
    func getUsersWithRx() {
        self.isLoading = true
        WebService.getUsersDataWithRx()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                with: self,
                onNext: { owner, users in
                    owner.isLoading = false
                    owner.shouldShowError = false
                    owner.users = users
                },
                onError: { owner, error in
                    owner.isLoading = false
                    owner.shouldShowError = true
                    owner.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: self.disposeBag)
    }
}
