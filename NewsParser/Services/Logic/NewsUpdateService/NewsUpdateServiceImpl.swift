//
//  NewsProviderImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import UIKit

final class NewsUpdateServiceImpl: NewsUpdateService {
	var newsUpdateCompletionAction: (() -> Void)?

	private let networkService: NetworkService
	private let newsParserProvider: NewsParserProvider
	private let sourcesProvider: NewsSourcesProvider
	private let storageManager: StorageManager

	init(
		networkService: NetworkService,
		newsParserProvider: NewsParserProvider,
		sourcesProvider: NewsSourcesProvider,
		storageManager: StorageManager
	) {
		self.newsParserProvider = newsParserProvider
		self.networkService = networkService
		self.sourcesProvider = sourcesProvider
		self.storageManager = storageManager
	}

	func update(newsArticle: NewsArticle) {
		storageManager.update(newsArticle)
	}

	func update(newsArticle: NewsArticle, withImageData imageData: Data) {
		let articleWithImageData = newsArticle.appendImageData(imageData)
		storageManager.update(articleWithImageData)
	}

	func fetchNewsToStorage() async {
		defer {
			newsUpdateCompletionAction?()
		}

		guard storageManager.isStorageEmpty() else {
			LoggerImpl.shared.debug(
				"Stopped updating news because storage is not empty",
				type: .info
			)
			return
		}
		var resultNewsArticles = [NewsArticle]()
		let newsSources = sourcesProvider.getNewsSources()
		for source in newsSources {
			do {
				let newsData = try await networkService.fetchNewsData(newsSource: source)
				let parser = newsParserProvider.getParser(for: newsData, source: source)
				let deserializableArticles = try parser.parseNews()
				let newsArticles = deserializableArticles.map { $0.makeNewsArticle() }
				resultNewsArticles.append(contentsOf: newsArticles)
			} catch let error {
				LoggerImpl.shared.debug(
					"Can't fetch data of news from source: \(source.url.absoluteString), format: \(source.format)",
					type: .error(error.localizedDescription)
				)
			}
		}
		LoggerImpl.shared.debug(
			"Successfully fetched news articles from network and parses them to [NewsArticle].",
			type: .success
		)
		await storageManager.appendNewsArticles(resultNewsArticles)
	}

	func fetchNewsToStorageAfterRemovingPast() async {
		if networkService.isNetworkAvailable() {
			storageManager.removeAllNews()
			await fetchNewsToStorage()
		} else {
			LoggerImpl.shared.debug(
				"News updating interrupted because no internet connection.",
				type: .error(nil)
			)
		}
	}
}

extension NewsArticle {
	fileprivate func appendImageData(_ imageData: Data) -> NewsArticle {
		NewsArticle(
			id: self.id,
			title: self.title,
			source: self.source,
			description: self.description,
			publicationDate: self.publicationDate,
			sourceUrl: self.sourceUrl,
			imageUrl: self.imageUrl,
			imageData: imageData,
			isOpened: self.isOpened
		)
	}
}
