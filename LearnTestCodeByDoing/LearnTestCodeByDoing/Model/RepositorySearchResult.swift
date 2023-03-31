//
//  RepositorySearchResult.swift
//  LearnTestCodeByDoing
//
//  Created by JeongminKim on 2023/03/29.
//

import Foundation

struct RepositorySearchResult: Codable {
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}
