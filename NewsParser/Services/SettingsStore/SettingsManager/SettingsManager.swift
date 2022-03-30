//
//  SettingsStoreManager.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 27.03.2022.
//

import Foundation

protocol SettingsManager: NewsSourcesProvider, SettingsTimerIntervalController {
	func makeFirstLaunchSetup()

	func updateNewsSources(_ newsSources: [NewsSource])
}
