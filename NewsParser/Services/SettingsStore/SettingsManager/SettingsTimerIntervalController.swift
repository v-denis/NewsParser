//
//  SettingsTimerIntervalController.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 30.03.2022.
//

import Foundation

protocol SettingsTimerIntervalController {
	var timerIntervalUpdateCompletion: (() -> Void)? { get set }

	func getStoredTimerInterval() -> Int
	func updateTimerInterval(_ timerInterval: Int)
}
