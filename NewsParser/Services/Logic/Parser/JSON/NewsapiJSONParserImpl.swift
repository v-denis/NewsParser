//
//  NewsJSONParserImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

final class NewsapiJSONParserImpl: NewsJSONParser {
	private let jsonParser: JSONDecoder
	private let jsonData: Data
	private let newsSource: NewsSource

	init(withJSONData data: Data, from source: NewsSource) {
		self.jsonData = data
		self.newsSource = source
		jsonParser = JSONDecoder()
	}

	func parseNews() throws -> [NewsArticleDeserializable] {
		do {
			let news = try jsonParser.decode(JsonNews.self, from: jsonData)
			return news.articles.addJsonSource(newsSource.url)
		} catch {
			throw error
		}
	}
}

extension Array where Element == JsonNewsArticle {
	fileprivate func addJsonSource(_ url: URL) -> [JsonNewsArticle] {
		var resultArticles = [JsonNewsArticle]()
		self.forEach {
			resultArticles.append(
				JsonNewsArticle(
					source: $0.source,
					author: $0.author,
					title: $0.title,
					description: $0.description,
					url: $0.url,
					urlToImage: $0.urlToImage,
					publishedAt: $0.publishedAt,
					content: $0.content,
					jsonSource: url
				)
			)
		}
		return resultArticles
	}
}
