//
//  DataStoreManagerImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 23.03.2022.
//

import Foundation
import CoreData

class StorageManagerImpl: StorageManager {
	private let contextProvider: ContextProvider

	init(contextProvider: ContextProvider) {
		self.contextProvider = contextProvider
	}

	private var viewContext: NSManagedObjectContext {
		contextProvider.viewContext
	}

	private var backgroundContext: NSManagedObjectContext {
		contextProvider.backgroundContext
	}

	func removeAllNews() {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NewsArticleEntity.entityName)
		guard let newsArticles = try? viewContext.fetch(fetchRequest) as? [NewsArticleEntity] else {
			LoggerImpl.shared.debug(
				"Can't save received NewsArticles from storage because can't be fetched or casted!",
				type: .warning
			)
			return
		}
		guard !newsArticles.isEmpty else {
			LoggerImpl.shared.debug(
				"Can't delete from storage because it's already empty!",
				type: .warning
			)
			return
		}
		for article in newsArticles {
			viewContext.delete(article)
		}
		saveViewContext()
	}

	func appendNewsArticles(_ newsArticles: [NewsArticle]) async {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NewsArticleEntity.entityName)
		guard let newsArticleEntities = try? viewContext.fetch(fetchRequest) as? [NewsArticleEntity] else {
			LoggerImpl.shared.debug(
				"Can't save received NewsArticles from storage because can't be fetched or casted!",
				type: .warning
			)
			return
		}
		guard newsArticleEntities.isEmpty else {
			LoggerImpl.shared.debug(
				"Can't save received NewsArticles because storage is not empty!",
				type: .warning
			)
			return
		}

		for article in newsArticles {
			await self.backgroundContext.perform { [weak self] in
				guard let self = self else { return }
				let newsArticleEntity = NewsArticleEntity(context: self.backgroundContext)
				newsArticleEntity.setup(from: article)
			}
		}
		do {
			try self.backgroundContext.save()
			LoggerImpl.shared.debug(
				"Successfully saved [NewsArticleEntity] to CoreData.",
				type: .success
			)
		} catch let error {
			LoggerImpl.shared.debug(
				"Can't save [NewsArticleEntity] in: NSManagedObjectContext!",
				type: .error(error.localizedDescription)
			)
		}
	}

	func update(_ newsArticle: NewsArticle) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NewsArticleEntity.entityName)
		fetchRequest.predicate = NSPredicate(
			format: "%K == %@",
			#keyPath(NewsArticleEntity.articleId),
			newsArticle.id as CVarArg
		)
		fetchRequest.fetchBatchSize = 1
		do {
			if let newsArticlesEntities = try viewContext.fetch(fetchRequest) as? [NewsArticleEntity] {
				guard let articleEntity = newsArticlesEntities.first else {
					LoggerImpl.shared.debug(
						"Fetched from storage [NewsArticleEntity] by UUID is empty in: \(#function)",
						type: .error(nil)
					)
					return
				}
				articleEntity.setup(from: newsArticle)
				try viewContext.save()
			} else {
				LoggerImpl.shared.debug(
					"Can't fetch [NewsArticleEntity] by UUID from storage in \(#function)",
					type: .error(nil)
				)
			}
		} catch let error {
			LoggerImpl.shared.debug(
				"Can't find NewsArticle by UUID in storage: \(#function)",
				type: .error(error.localizedDescription)
			)
		}
	}

	func update(_ newsArticle: NewsArticle, completion: @escaping () -> Void) {
		update(newsArticle)
		completion()
	}

	func isStorageEmpty() -> Bool {
		checkEmptyStorage(with: nil)
	}

	private func saveViewContext() {
		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				let nsError = error as NSError
				LoggerImpl.shared.debug(
					"Can't commit unsaved changes by NSManagedObjectContext.",
					type: .error("\(nsError.description), \(nsError.userInfo)")
				)
			}
		}
	}

	private func checkEmptyStorage(with predicate: NSPredicate?) -> Bool {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NewsArticleEntity.entityName)
		fetchRequest.predicate = predicate
		do {
			if let entities = try viewContext.fetch(fetchRequest) as? [NewsArticleEntity] {
				return entities.isEmpty
			}
			return true
		} catch {
			LoggerImpl.shared.debug(
				"Can't find fetch [NewsArticleEntity] from storage in: \(#function)",
				type: .error(error.localizedDescription)
			)
			return true
		}
	}
}

extension NewsArticleEntity {
	fileprivate func setup(from newsArticle: NewsArticle) {
		self.title = newsArticle.title
		self.source = newsArticle.source
		self.imageUrl = newsArticle.imageUrl
		self.sourceUrl = newsArticle.sourceUrl
		self.isOpened = newsArticle.isOpened
		self.descriptionText = newsArticle.description
		self.publicationDate = newsArticle.publicationDate
		self.articleId = newsArticle.id
		self.imageData = newsArticle.imageData ?? self.imageData
	}
}
