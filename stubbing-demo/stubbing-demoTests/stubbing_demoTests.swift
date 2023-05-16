//
//  stubbing_demoTests.swift
//  stubbing-demoTests
//
//  Created by JeongminKim on 2023/05/16.
//

import XCTest
import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import stubbing_demo

final class stubbing_demoTests: XCTestCase {
    
    private var sut: ProfileService!
    private var cancellable: AnyCancellable?
    
    override func setUp() {
        sut = .init()
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testHappyPath() {
        // given
        let exp = XCTestExpectation(description: "should receive profile")
        let exp2 = XCTestExpectation(description: "should receive profile")
        
        stub(condition: isHost("www.jsonkeeper.com")) { _ in
          // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
          let stubPath = OHPathForFile("mock_profile_valid_response.json", type(of: self))
          return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        // when
        cancellable = sut.fetchProfile().sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                XCTFail("not expected to land here - error: \(error)")
            case .finished:
                exp2.fulfill()
            }
        }, receiveValue: { profile in
            exp.fulfill()
            XCTAssertEqual(profile.name, "brandon")
            XCTAssertEqual(profile.email, "brandon@gmail.com")
        })
        
        // then
        wait(for: [exp, exp2], timeout: 0.1)
    }

    func testUnhappyPath() {
        // given
        let exp = XCTestExpectation(description: "should receive profile")
        
        stub(condition: isHost("www.jsonkeeper.com")) { _ in
          // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
          let stubPath = OHPathForFile("mock_profile_invalid_response.json", type(of: self))
          return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        // when
        cancellable = sut.fetchProfile().sink(receiveCompletion: { completion in
            switch completion {
            case .failure:
                exp.fulfill()
            case .finished:
                XCTFail("not supposed to finish")
            }
        }, receiveValue: { profile in
            XCTFail("not supposed to receive profile")
        })
        
        // then
        wait(for: [exp], timeout: 0.1)
    }
}
