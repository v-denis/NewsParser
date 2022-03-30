//
//  SettingsViewModel.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 22.03.2022.
//

import Foundation

final class SettingsViewModel {
	let fetchedNewsSources: [NewsSource]
	let fetchedTimeInterval: Int

	let availableTimeIntervals: [Int] = [0, 10, 30, 60, 90, 120, 150, 180]

	var steps: Step?
	var outputs: Output?
	lazy var inputs: Input = Input(
		saveButtonTap: { [weak self] in self?.updateSettingsAndReloadNewsIfNeeded($0) }
	)

	private let newsUpdateService: NewsUpdateService
	private let settingsManager: SettingsManager

	init(
		settingsManager: SettingsManager,
		newsUpdateService: NewsUpdateService
	) {
		self.settingsManager = settingsManager
		self.newsUpdateService = newsUpdateService
		self.fetchedNewsSources = settingsManager.getNewsSources()
		self.fetchedTimeInterval = settingsManager.getStoredTimerInterval()
	}

	private func updateSettingsAndReloadNewsIfNeeded(_ settings: UserSettings) {
		if settings.newsUpdateTimeInterval != fetchedTimeInterval {
			settingsManager.updateTimerInterval(settings.newsUpdateTimeInterval)
		}

		if !settings.newsSources.isEquals(to: fetchedNewsSources) {
			settingsManager.updateNewsSources(settings.newsSources)
			Task {
				await newsUpdateService.fetchNewsToStorage()
			}
		}
	}
}

// MARK: - IViewModeling

extension SettingsViewModel: IViewModeling {
	struct Input {
		let saveButtonTap: InputAction<UserSettings>
	}
	struct Output {}
	struct Step {}
}

// MARK: - Helpers

extension Array where Element == NewsSource {
	func isEquals(to newsSources: [NewsSource]) -> Bool {
		guard newsSources.count == self.count else { return false }
		for (index, newsSource) in self.enumerated() {
			if newsSource != newsSources[index] {
				return false
			}
		}
		return true
	}
}
