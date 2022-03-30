//
//  XmlNewsArticle.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 22.03.2022.
//

import Foundation

struct XmlNewsArticle {
	let xmlSource: URL
	
	var title: String?
	var author: String?
	var sourceLink: String?
	var enclosureUrl: String?
	var enclosureType: String?
	var description: String?
	var category: String?
	var publicationDate: String?
}

extension XmlNewsArticle: NewsArticleDeserializable {
	func makeNewsArticle() -> NewsArticle {
		let title = getStringOrLog(from: title, propertyName: "Title")
		let sourceUrl = getStringOrLog(from: sourceLink, propertyName: "Source Link").makeUrl()
		let imageUrl = getStringOrLog(from: enclosureUrl, propertyName: "Image Link").makeUrl()
		let description = getStringOrLog(from: description, propertyName: "Description Text")
		let date = getStringOrLog(
			from: publicationDate,
			propertyName: "Article date"
		).getDate(newsSourceFormat: .xml)
		let source = xmlSource.domainName()

		return NewsArticle(
			id: UUID(),
			title: title,
			source: source,
			description: description,
			publicationDate: date,
			sourceUrl: sourceUrl,
			imageUrl: imageUrl
		)
	}

	private func getStringOrLog(from text: String?, propertyName: String) -> String {
		guard let resultText = text
		else {
			LoggerImpl.shared.debug(
				"Don't have \(propertyName) in XML for NewsArticle model in: \(#function)",
				type: .warning
			)
			return ""
		}
		return resultText
	}
}
