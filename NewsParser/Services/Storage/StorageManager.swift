//
//  StorageManager.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 24.03.2022.
//

import CoreData
import Foundation

protocol StorageManager {
	func appendNewsArticles(_ newsArticles: [NewsArticle]) async

	func update(_ newsArticle: NewsArticle)
	func update(_ newsArticle: NewsArticle, completion: @escaping () -> Void)

	func isStorageEmpty() -> Bool

	func removeAllNews()
}
