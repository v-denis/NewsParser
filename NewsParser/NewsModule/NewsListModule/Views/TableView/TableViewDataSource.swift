//
//  TableViewDataSource.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 30.03.2022.
//

import CoreData
import UIKit

final class NewsTableViewDataSource: NSObject {
	var updateNewsArticleImageAction: ((NewsArticle, IndexPath) -> Void)?
	var newsArticleTapAction: ((NewsArticle, IndexPath) -> Void)?

	private let fetchedResultController: NSFetchedResultsController<NewsArticleEntity>
	private let contextProvider: ContextProvider
	private let newsSourcesProvider: NewsSourcesProvider

	private var fetchRequestPredicate: NSPredicate {
		let sourceNames = newsSourcesProvider.getNewsSources()
			.filter { $0.isEnabled }
			.map { $0.url.domainName() }
		return NSPredicate(format: "source IN %@", sourceNames)
	}

	init(
		contextProvider: ContextProvider,
		newsSourcesProvider: NewsSourcesProvider
	) {
		self.contextProvider = contextProvider
		self.newsSourcesProvider = newsSourcesProvider

		let fetchRequest = NewsArticleEntity.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publicationDate", ascending: false)]

		let sourceNames = newsSourcesProvider.getNewsSources()
			.filter { $0.isEnabled }
			.map { $0.url.domainName() }
		fetchRequest.predicate = NSPredicate(format: "source IN %@", sourceNames)

		self.fetchedResultController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: contextProvider.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)
	}

	func performFetch() {
		do {
			try fetchedResultController.performFetch()
		} catch let error {
			LoggerImpl.shared.debug(
				"NewsTableViewDataSource can't perform fetch in: \(#function)",
				type: .error(error.localizedDescription)
			)
		}
	}

	func updatePredicateAndPerformFetch() {
		fetchedResultController.fetchRequest.predicate = fetchRequestPredicate
		performFetch()
	}
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension NewsTableViewDataSource: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		fetchedResultController.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = fetchedResultController.sections?[section]
		return sectionInfo?.numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueNewsListCell(forIndexPath: indexPath)
		let newsArticle = fetchedResultController.object(at: indexPath).getNewsArticle()
		if newsArticle.imageData == nil {
			updateNewsArticleImageAction?(newsArticle, indexPath)
		}
		cell.configure(with: newsArticle)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let newsArticle = fetchedResultController.object(at: indexPath).getNewsArticle()
		newsArticleTapAction?(newsArticle, indexPath)
	}
}
