//
//  ErrorCases.swift
//  AsyncAwaitSwiftUI
//
//  Created by 김정민 on 5/2/24.
//

import Foundation

enum ErrorCases: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL found"
        case .invalidResponse:
            return "Invalid response found"
        case .invalidData:
            return "Invalid data"
        }
    }
}
