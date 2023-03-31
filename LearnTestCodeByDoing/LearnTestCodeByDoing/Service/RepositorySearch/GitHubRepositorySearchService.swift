//
//  GitHubRepositorySearchService.swift
//  LearnTestCodeByDoing
//
//  Created by JeongminKim on 2023/03/29.
//

import Foundation

final class GitHubRepositorySearchService {
    static let shared = GitHubRepositorySearchService()
    
    func searchRepositories(
        by name: String,
        completion: @escaping (Result<[Repository], Error>) -> Void
    ) {
        Task {
            do {
                let url = createSearchRepositoryByNameURL(name: name)
                let (data, _) = try await URLSession.shared.data(from: url)
                let result = try JSONDecoder().decode(RepositorySearchResult.self, from: data)
                completion(.success(result.items))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func createSearchRepositoryByNameURL(name: String) -> URL {
        return URL(string: "https://api.github.com/search/repositories?q=\(name)")!
    }
}
