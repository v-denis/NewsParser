//
//  NewsUpdateCallerImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 28.03.2022.
//

import Foundation

final class NewsUpdateCallerImpl: NewsUpdateCaller {
	private let newsUpdateService: NewsUpdateService
	private var timeIntervalController: SettingsTimerIntervalController

	private var timerInterval: Int
	private var timer: Timer?

	init(
		newsUpdateService: NewsUpdateService,
		timeIntervalController: SettingsTimerIntervalController
	) {
		self.timeIntervalController = timeIntervalController
		self.newsUpdateService = newsUpdateService
		timerInterval = self.timeIntervalController.getStoredTimerInterval()
		startTimerIfPossible()
		configureTimerIntervalController()
	}

	private func configureTimerIntervalController() {
		self.timeIntervalController.timerIntervalUpdateCompletion = { [weak self] in
			guard let self = self else { return }
			self.timerInterval = self.timeIntervalController.getStoredTimerInterval()
			self.startTimerIfPossible()
		}
	}

	private func startTimerIfPossible() {
		guard timerInterval > 0 else {
			invalidateTimer()
			LoggerImpl.shared.debug(
				"Update by timer is turned off because timerInterval <= 0 seconds.",
				type: .info
			)
			return
		}
		self.timer = Timer.scheduledTimer(
			timeInterval: TimeInterval(timerInterval),
			target: self,
			selector: #selector(timerAction),
			userInfo: nil,
			repeats: true
		)
		LoggerImpl.shared.debug(
			"Timer scheduled for updating every \(timerInterval) seconds.",
			type: .info
		)
	}

	@objc private func timerAction() {
		Task {
			await newsUpdateService.fetchNewsToStorageAfterRemovingPast()
			LoggerImpl.shared.debug(
				"UpdateCaller triggers news articles update by timer.",
				type: .info
			)
		}
	}

	private func invalidateTimer() {
		timer?.invalidate()
		timer = nil
	}
}
