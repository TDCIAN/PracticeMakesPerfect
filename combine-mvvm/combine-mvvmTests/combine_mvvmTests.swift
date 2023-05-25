//
//  combine_mvvmTests.swift
//  combine-mvvmTests
//
//  Created by JeongminKim on 2023/05/25.
//

import XCTest
import Combine
@testable import combine_mvvm

final class combine_mvvmTests: XCTestCase {
    
    var sut: QuoteViewModel!
    var quoteService: MockQuoteServiceType!

    override func setUp() {
        quoteService = MockQuoteServiceType()
        sut = QuoteViewModel(quoteServiceType: quoteService)
    }

    override func tearDown() {
        sut = nil
        quoteService = nil
    }
}

class MockQuoteServiceType: QuoteServiceType {
    var value: AnyPublisher<Quote, Error>?
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        return value ?? Empty().eraseToAnyPublisher()
    }
}
