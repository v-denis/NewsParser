//
//  NetworkReachabilityMock.swift
//  NewsParserTests
//
//  Created by Denis Valshchikov on 31.03.2022.
//

import Foundation
@testable import NewsParser

final class NetworkReachabilityMock: NetworkReachability {
	var debugNetworkIsAvailable: Bool?

	func isNetworkAvailable() -> Bool {
		debugNetworkIsAvailable ?? false
	}
}
