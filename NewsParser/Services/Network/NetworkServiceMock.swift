//
//  File.swift
//  NewsParserTests
//
//  Created by Denis Valshchikov on 31.03.2022.
//

import Foundation
@testable import NewsParser

enum TestError: Error {
	case mock
}

final class NetworkServiceMock: NetworkService {
	var debugNetworkAvailableStatus: Bool?
	var debugNewsData: Data?
	var debugImageData: Data?

	var debugFetchError: Error?

	func isNetworkAvailable() -> Bool {
		debugNetworkAvailableStatus ?? false
	}

	func fetchNewsData(newsSource: NewsSource) async throws -> Data {
		if let error = debugFetchError {
			throw error
		}
		return debugNewsData ?? Data()
	}

	func fetchDataImage(from url: URL) async throws -> Data {
		if let error = debugFetchError {
			throw error
		}
		return debugImageData ?? Data()
	}
}
