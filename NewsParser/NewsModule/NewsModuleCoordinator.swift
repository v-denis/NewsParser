//
//  CoordinatorImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 22.03.2022.
//

import UIKit

final class NewsModuleCoordinator: BaseCoordinator {
	private let navigationController = UINavigationController()

	private var startTransition: TransitionType?

	public override func start(withTransition transition: TransitionType) {
		self.startTransition = transition

		let settingsManager = ObjectHolderImpl.shared.settingsManager
		let contextProvider = ObjectHolderImpl.shared.contextProvider
		let networkService = ObjectHolderImpl.shared.networkService
		let storageManager = ObjectHolderImpl.shared.storageManager
		let imageProvider = ImageProviderImpl(networkService: networkService)
		var newsUpdateService = ObjectHolderImpl.shared.newsUpdateService
		let tableViewDataSource = NewsTableViewDataSource(
			contextProvider: contextProvider,
			newsSourcesProvider: settingsManager
		)
		let viewModel = NewsListViewModel(
			newsUpdateService: newsUpdateService,
			storageManager: storageManager,
			imageProvider: imageProvider,
			tableViewDataSource: tableViewDataSource
		)

		viewModel.steps = NewsListViewModel.Step(
			openNewsDetailScreen: { [weak self] newsArticle in
				self?.openNewsDetailController(newsArticle: newsArticle)
			},
			openSettingsScreen: { [weak self] in
				self?.openSettingsController(
					settingsManager: settingsManager,
					newsUpdateService: newsUpdateService
				)
			}
		)
		newsUpdateService.newsUpdateCompletionAction = { [weak viewModel] in
			viewModel?.reloadContentAction()
		}
		let newsListController = NewsListController(viewModel: viewModel)
		navigationController.setViewControllers([newsListController], animated: false)
		navigationController.show(withTransition: transition)
	}

	private func openSettingsController(settingsManager: SettingsManager, newsUpdateService: NewsUpdateService) {
		let viewModel = SettingsViewModel(
			settingsManager: settingsManager,
			newsUpdateService: newsUpdateService
		)
		let settingsController = SettingsController(viewModel: viewModel)
		settingsController.show(withTransition: .modal(
			root: navigationController,
			presentationStyle: .automatic,
			animated: true)
		)
	}

	private func openNewsDetailController(newsArticle: NewsArticle) {
		let newsDetailController = NewsDetailController(newsArticle: newsArticle)
		newsDetailController.show(withTransition: .push(root: navigationController, animated: true))
	}
}
