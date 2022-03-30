//
//  NewsArticleEntity+CoreDataClass.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 23.03.2022.
//
//

import Foundation
import CoreData

@objc(NewsArticleEntity)
public class NewsArticleEntity: NSManagedObject {
	static let entityName = "NewsArticleEntity"

	func getNewsArticle() -> NewsArticle {
		NewsArticle(
			id: articleId ?? UUID(),
			title: title ?? "???",
			source: source ?? "???",
			description: descriptionText ?? "???",
			publicationDate: publicationDate ?? Date(),
			sourceUrl:  sourceUrl,
			imageUrl: imageUrl,
			imageData: imageData,
			isOpened: isOpened
		)
	}
}
