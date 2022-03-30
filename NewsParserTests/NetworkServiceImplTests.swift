//
//  NetworkServiceImplTests.swift
//  NewsParserTests
//
//  Created by Denis Valshchikov on 31.03.2022.
//

import XCTest
@testable import NewsParser

class NetworkServiceImplTests: XCTestCase {
	private lazy var sut = NetworkServiceImpl(networkReachability: networkReachability)

	private let networkReachability = NetworkReachabilityMock()

	func test_IsNetworkAvailable_WhenGetFalseFromNetworkReachability_ReturnsFalse() {
		let testValue = false
		networkReachability.debugNetworkIsAvailable = testValue

		let result = sut.isNetworkAvailable()

		XCTAssertEqual(testValue, result)
	}

	func test_IsNetworkAvailable_WhenGetTrueFromNetworkReachability_ReturnsTrue() {
		let testValue = true
		networkReachability.debugNetworkIsAvailable = testValue

		let result = sut.isNetworkAvailable()

		XCTAssertEqual(testValue, result)
	}
}
