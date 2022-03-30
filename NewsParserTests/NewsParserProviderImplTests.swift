//
//  NewsParserProviderImplTests.swift
//  NewsParserTests
//
//  Created by Denis Valshchikov on 31.03.2022.
//

import XCTest
@testable import NewsParser

class NewsParserProviderImplTests: XCTestCase {
	private lazy var sut = NewsParserProviderImpl()

	func test_GetParser_WhenSourceIsLenta_ReturnsBasicXMLParser() {
		let parser = sut.getParser(for: Data(), source: .lenta!)

		XCTAssertTrue(parser is BasicXMLParserImpl)
	}

	func test_GetParser_WhenSourceIsVedomosti_ReturnsBasicXMLParser() {
		let parser = sut.getParser(for: Data(), source: .vedomosti!)

		XCTAssertTrue(parser is BasicXMLParserImpl)
	}

	func test_GetParser_WhenSourceIsNewsapi_ReturnsNewsapiJSONParser() {
		let parser = sut.getParser(for: Data(), source: .newsapi!)

		XCTAssertTrue(parser is NewsapiJSONParserImpl)
	}
}
