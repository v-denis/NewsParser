//
//  Article.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

/// Модель одной новостной статьи UI-слоя
struct NewsArticle {
	let id: UUID
	let title: String
	let source: String
	let description: String
	let publicationDate: Date
	let sourceUrl: URL?
	let imageUrl: URL?
	var imageData: Data?

	var isOpened: Bool

	init(
		id: UUID,
		title: String,
		source: String,
		description: String,
		publicationDate: Date,
		sourceUrl: URL?,
		imageUrl: URL?,
		imageData: Data? = nil,
		isOpened: Bool = false
	) {
		self.id = id
		self.title = title
		self.source = source
		self.description = description
		self.publicationDate = publicationDate
		self.sourceUrl = sourceUrl
		self.imageUrl = imageUrl
		self.isOpened = isOpened
		self.imageData = imageData
	}
}

