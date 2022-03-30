//
//  NetworkService.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

protocol NetworkService {
	func isNetworkAvailable() -> Bool

	func fetchNewsData(newsSource: NewsSource) async throws -> Data
	func fetchDataImage(from url: URL) async throws -> Data
}
