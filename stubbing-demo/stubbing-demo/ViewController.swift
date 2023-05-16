//
//  ViewController.swift
//  stubbing-demo
//
//  Created by JeongminKim on 2023/05/16.
//

import UIKit
import Combine
import OHHTTPStubs
import OHHTTPStubsSwift

class ViewController: UIViewController {

    private let profileService = ProfileService()
    private var cancellables: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stub(condition: isHost("www.jsonkeeper.com")) { _ in
          // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
          let stubPath = OHPathForFile("mock_profile_response.json", type(of: self))
          return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        cancellables = profileService
            .fetchProfile()
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { profile in
                print("name: \(profile.name), email: \(profile.email)")
            })
    }


}

struct Profile: Decodable {
    let name: String
    let email: String
}

class ProfileService {
    func fetchProfile() -> AnyPublisher<Profile, Error> {
        let urlString = "https://www.jsonkeeper.com/b/OSEJ"
        let url = URL(string: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Profile.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
