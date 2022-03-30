//
//  NewsListViewModel.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 18.03.2022.
//

import CoreData
import Foundation

typealias CellInfo = (article: NewsArticle, indexPath: IndexPath)

final class NewsListViewModel {
	let tableViewDataSource: NewsTableViewDataSource

	var steps: Step?
	var outputs: Output?
	lazy var inputs: Input = Input(
		newsArticleTap: { [weak self] in self?.newsArticleTapAction($0.article, at: $0.indexPath) },
		newsArticleShown: { [weak self] in self?.fetchAndUpdateNewsArticleImage($0.article, at: $0.indexPath) },
		settingsButtonTap: { [weak self] in self?.steps?.openSettingsScreen(()) }
	)
	lazy var reloadContentAction: () -> Void = { [weak self] in self?.reloadContent() }

	private let storageManager: StorageManager
	private let newsUpdateService: NewsUpdateService
	private let imageProvider: ImageProvider

	init(
		newsUpdateService: NewsUpdateService,
		storageManager: StorageManager,
		imageProvider: ImageProvider,
		tableViewDataSource: NewsTableViewDataSource
	) {
		self.newsUpdateService = newsUpdateService
		self.storageManager = storageManager
		self.imageProvider = imageProvider
		self.tableViewDataSource = tableViewDataSource

		tableViewDataSource.newsArticleTapAction = { [weak self] in
			self?.newsArticleTapAction($0, at: $1)
		}
		tableViewDataSource.updateNewsArticleImageAction = { [weak self] in
			self?.fetchAndUpdateNewsArticleImage($0, at: $1)
		}
		self.fetchNews()
	}

	private func fetchNews() {
		Task {
			await newsUpdateService.fetchNewsToStorage()
			tableViewDataSource.performFetch()
			DispatchQueue.main.async { [weak self] in
				self?.outputs?.reloadTableView(())
			}
		}
	}

	private func newsArticleTapAction(_ newsArticle: NewsArticle, at indexPath: IndexPath) {
		var newsArticle = newsArticle
		newsArticle.isOpened = true
		steps?.openNewsDetailScreen(newsArticle)
		storageManager.update(newsArticle) { [weak self] in
			self?.outputs?.reloadNewsArticleCell(indexPath)
		}
	}

	private func fetchAndUpdateNewsArticleImage(_ newsArticle: NewsArticle, at indexPath: IndexPath) {
		guard newsArticle.imageData == nil else { return }

		Task {
			if let imageUrl = newsArticle.imageUrl,
			   let imageData = await imageProvider.getImageData(from: imageUrl) {
				newsUpdateService.update(
					newsArticle: newsArticle,
					withImageData: imageData
				)
			} else {
				newsUpdateService.update(
					newsArticle: newsArticle,
					withImageData: imageProvider.getDummyImageData()
				)
			}
			DispatchQueue.main.async { [weak self] in
				self?.outputs?.reloadNewsArticleCell(indexPath)
			}
		}
	}

	private func reloadContent() {
		tableViewDataSource.updatePredicateAndPerformFetch()
		DispatchQueue.main.async {
			self.outputs?.reloadTableView(())
		}
	}
}

// MARK: - IViewModeling

extension NewsListViewModel: IViewModeling {
	struct Input {
		let newsArticleTap: InputAction<CellInfo>
		let newsArticleShown: InputAction<CellInfo>
		let settingsButtonTap: InputAction<Void>
	}

	struct Output {
		let reloadTableView: OutputAction<Void>
		let reloadNewsArticleCell: OutputAction<IndexPath>
	}

	struct Step {
		let openNewsDetailScreen: StepAction<NewsArticle>
		let openSettingsScreen: StepAction<Void>
	}
}

