//
//  NewsProvider.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

protocol NewsUpdateService {
	var newsUpdateCompletionAction: (() -> Void)? { get set }
	
	func fetchNewsToStorage() async
	func fetchNewsToStorageAfterRemovingPast() async

	func update(newsArticle: NewsArticle)
	func update(newsArticle: NewsArticle, withImageData imageData: Data)
}
