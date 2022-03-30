//
//  JsonNewsDeserializable.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 22.03.2022.
//

import Foundation

/// Содержит массив из нескольких новостных статей (множественное число) в формате JSON
struct JsonNews: Decodable {
	var articles: [JsonNewsArticle]
}

/// Одна новостная статья в формате JSON
struct JsonNewsArticle: Decodable {
	struct Source: Decodable {
		var name: String?
	}

	var source: Source?
	var author: String?
	var title: String?
	var description: String?
	var url: String?
	var urlToImage: String?
	var publishedAt: String?
	var content: String?
	var jsonSource: URL?

	init(
		source: Source?,
		author: String?,
		title: String?,
		description: String?,
		url: String?,
		urlToImage: String?,
		publishedAt: String?,
		content: String?,
		jsonSource: URL?
	) {
		self.source = source
		self.author = author
		self.title = title
		self.description = description
		self.url = url
		self.urlToImage = urlToImage
		self.publishedAt = publishedAt
		self.content = content
		self.jsonSource = jsonSource
	}
}

// MARK: - NewsArticleDeserializable

extension JsonNewsArticle: NewsArticleDeserializable {
	func makeNewsArticle() -> NewsArticle {
		let title = getStringOrLog(from: title, propertyName: "Title")
		let sourceUrl = getStringOrLog(
			from: url,
			propertyName: "Source URL"
		).makeUrl()

		let imageUrl = getStringOrLog(
			from: urlToImage,
			propertyName: "Image URL"
		).makeUrl()

		let description = getStringOrLog(
			from: description,
			propertyName: "Description"
		).replacingOccurrences(of: "&nbsp;", with: " ")

		let publicationDate = getStringOrLog(
			from: publishedAt,
			propertyName: "Publication date"
		).getDate(newsSourceFormat: .json)
		let source = jsonSource?.domainName()
		?? sourceUrl?.domainName()
		?? getStringOrLog(from: source?.name, propertyName: "Source")

		return NewsArticle(
			id: UUID(),
			title: title,
			source: source,
			description: description,
			publicationDate: publicationDate,
			sourceUrl: sourceUrl,
			imageUrl: imageUrl
		)
	}

	private func getStringOrLog(from text: String?, propertyName: String) -> String {
		guard let resultText = text
		else {
			LoggerImpl.shared.debug(
				"Don't have \(propertyName) in JSON for NewsArticle model in: \(#function)",
				type: .warning
			)
			return ""
		}
		return resultText
	}
}
