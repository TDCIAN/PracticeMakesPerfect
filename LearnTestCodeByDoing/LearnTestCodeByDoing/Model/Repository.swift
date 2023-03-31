//
//  Repository.swift
//  LearnTestCodeByDoing
//
//  Created by JeongminKim on 2023/03/29.
//

import Foundation

struct Repository: Hashable, Codable {
    let name: String
    let stargazersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case stargazersCount = "stargazers_count"
    }
}
