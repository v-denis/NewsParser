//
//  ObjectHolderImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 30.03.2022.
//

import Foundation

final class ObjectHolderImpl: ObjectHolder {
	let newsUpdateCaller: NewsUpdateCaller
	let storageManager: StorageManager
	let networkService: NetworkService
	let newsParserProvider: NewsParserProvider
	let newsSourcesProvider: NewsSourcesProvider
	let settingsManager: SettingsManager
	let contextProvider: ContextProvider

	var newsUpdateService: NewsUpdateService

	static let shared = ObjectHolderImpl()

	private init() {
		let userDefaultsStorage = UserDefaultsManager()
		self.settingsManager = SettingsManagerImpl(userDefaultsStorage: userDefaultsStorage)
		settingsManager.makeFirstLaunchSetup()

		let networkReachability = NetworkReachabilityImpl()
		self.networkService = NetworkServiceImpl(networkReachability: networkReachability)
		self.contextProvider = ContextProviderImpl()
		self.storageManager = StorageManagerImpl(contextProvider: contextProvider)
		self.newsSourcesProvider = settingsManager
		self.newsParserProvider = NewsParserProviderImpl()

		self.newsUpdateService = NewsUpdateServiceImpl(
			networkService: networkService,
			newsParserProvider: newsParserProvider,
			sourcesProvider: settingsManager,
			storageManager: storageManager
		)
		self.newsUpdateCaller = NewsUpdateCallerImpl(
			newsUpdateService: newsUpdateService,
			timeIntervalController: settingsManager
		)
	}
}
