//
//  RepositoryListViewModel.swift
//  LearnTestCodeByDoing
//
//  Created by JeongminKim on 2023/03/29.
//

import Foundation

protocol RepositoryListViewModelAction {
    func search(repositoryName: String)
}

protocol RepositoryListViewModelDelegate: AnyObject {
    func setLoading(_ isLoading: Bool)
    func showRepositories(_ repositories: [Repository])
}

protocol RepositoryListViewModelType: AnyObject, RepositoryListViewModelAction {
    typealias Delegate = RepositoryListViewModelDelegate
    var delegate: Delegate? { get set }
}

final class RepositoryListViewModel: RepositoryListViewModelType {
    
    var delegate: Delegate?
    
    init() {
        
    }
    
    func search(repositoryName: String) {
        delegate?.setLoading(true)
        GitHubRepositorySearchService.shared.searchRepositories(by: repositoryName) { result in
            switch result {
            case let .success(repositories):
                self.delegate?.showRepositories(repositories)
                self.delegate?.setLoading(false)
            case .failure:
                self.delegate?.setLoading(false)
            }
        }
    }
    
    
}
