//
//  NewsNetworkServiceImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

final class NetworkServiceImpl: NetworkService {
	private let networkReachability: NetworkReachability

	init(networkReachability: NetworkReachability) {
		self.networkReachability = networkReachability
	}

	func fetchNewsData(newsSource: NewsSource) async throws -> Data {
		do {
			let (data, response) = try await URLSession.shared.data(from: newsSource.url)
			guard let httpResponse = response as? HTTPURLResponse,
				  httpResponse.statusCode == 200
			else {
				throw ResponseError.failedStatusCode
			}
			return data
		} catch {
			throw error
		}
	}

	func fetchDataImage(from url: URL) async throws -> Data {
		do {
			let (imageData, response) = try await URLSession.shared.data(from: url)
			guard let httpResponse = response as? HTTPURLResponse,
				  httpResponse.statusCode == 200
			else {
				throw ResponseError.failedStatusCode
			}
			return imageData
		} catch {
			throw error
		}
	}

	func isNetworkAvailable() -> Bool {
		networkReachability.isNetworkAvailable()
	}
}
