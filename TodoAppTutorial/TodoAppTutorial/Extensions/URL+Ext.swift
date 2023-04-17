//
//  URL+Ext.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/17.
//

import Foundation

extension URL {
    init?(baseUrl: String, queryItems: [String: String]) {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        
        urlComponents.queryItems = queryItems.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let finalUrlString = urlComponents.url?.absoluteString else {
            return nil
        }
        
        self.init(string: finalUrlString)
    }
}
