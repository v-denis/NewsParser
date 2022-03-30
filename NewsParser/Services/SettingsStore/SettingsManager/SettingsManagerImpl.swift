//
//  SettingsManagerImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 27.03.2022.
//

import Foundation

final class SettingsManagerImpl: SettingsManager {
	private let userDefaultsStorage: UserDefaultsManager

	var timerIntervalUpdateCompletion: (() -> Void)?

	init(userDefaultsStorage: UserDefaultsManager) {
		self.userDefaultsStorage = userDefaultsStorage
	}

	func getNewsSources() -> [NewsSource] {
		guard let sources = userDefaultsStorage.getObject(forKey: .newsSources) as? [NewsSource] else {
			LoggerImpl.shared.debug(
				"Can't downcast from Any? to [NewsSource] from UserDefaults in: \(#function)", type: .error(nil)
			)
			return []
		}
		return sources
	}

	func getStoredTimerInterval() -> Int {
		guard let timerValue = userDefaultsStorage.getObject(forKey: .timerInterval) as? Int else {
			LoggerImpl.shared.debug(
				"Can't downcast from Any? to Int from UserDefaults in: \(#function)", type: .error(nil)
			)
			return 0
		}
		return timerValue
	}


	func updateNewsSources(_ newsSources: [NewsSource]) {
		userDefaultsStorage.setObject(newsSources, forKey: .newsSources)
	}

	func updateTimerInterval(_ timerInterval: Int) {
		userDefaultsStorage.setObject(timerInterval, forKey: .timerInterval)
		timerIntervalUpdateCompletion?()
	}

	func makeFirstLaunchSetup() {
		if userDefaultsStorage.getObject(forKey: .firstLaunch) == nil ||
		   userDefaultsStorage.getObject(forKey: .firstLaunch) as? Bool == true {
			userDefaultsStorage.setObject(NewsSource.defaultSources, forKey: .newsSources)
			userDefaultsStorage.setObject(0, forKey: .timerInterval)
			userDefaultsStorage.setObject(false, forKey: .firstLaunch)
		}
		return
	}
}
