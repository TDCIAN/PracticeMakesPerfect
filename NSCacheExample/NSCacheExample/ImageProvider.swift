//
//  ImageProvider.swift
//  NSCacheExample
//
//  Created by 김정민 on 4/2/24.
//

import UIKit

class ImageProvider {
    static let shared = ImageProvider()
    
    private let cache = NSCache<NSString, UIImage>()
    private let cachingKey: NSString = "image"
    
    private init() {}
    
    public func fetchImage(completion: @escaping (UIImage?) -> Void) {
        if let image = cache.object(forKey: self.cachingKey) {
            print("Using cache")
            completion(image)
            return
        }
        
        guard let url = URL(string: "https://source.unsplash.com/random/500x500") else {
            completion(nil)
            return
        }
        print("Fetching Image")
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self, let data = data, error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                self.cache.setObject(image, forKey: self.cachingKey)
                completion(image)
            }
        }
        
        task.resume()
    }
}
