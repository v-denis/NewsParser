//
//  UserDefaultsStorage.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 27.03.2022.
//

import Foundation

final class UserDefaultsManager {
	enum Keys: String {
		case firstLaunch
		case newsSources
		case timerInterval
	}

	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
	}

	func setObject(_ object: Any, forKey key: Keys) {
		switch key {
		case .firstLaunch,
			 .timerInterval:
			userDefaults.set(object, forKey: key.rawValue)
			LoggerImpl.shared.debug(
				"Successfully saved \(key.rawValue) value to UserDefaults",
				type: .success
			)
		case .newsSources:
			guard let sources = object as? [NewsSource] else {
				LoggerImpl.shared.debug(
					"Can't downcast from Any to [NewsSource] to set object in: \(#function)",
					type: .error(nil)
				)
				return
			}
			let archivedSources = archiveNewsSources(sources)
			userDefaults.set(archivedSources, forKey: Keys.newsSources.rawValue)
			LoggerImpl.shared.debug(
				"Successfully saved [NewsSource] to UserDefaults",
				type: .success
			)
		}
		userDefaults.synchronize()
	}

	func getObject(forKey key: Keys) -> Any? {
		switch key {
		case .firstLaunch:
			return userDefaults.object(forKey: key.rawValue) as? Bool
		case .newsSources:
			let data = userDefaults.object(forKey: key.rawValue) as? Data
			return unarchiveNewsSources(from: data)
		case .timerInterval:
			return userDefaults.object(forKey: key.rawValue) as? Int
		}
	}

	private func archiveNewsSources(_ newsSources: [NewsSource]) -> NSData {
		do {
			let data = try NSKeyedArchiver.archivedData(
				withRootObject: newsSources as NSArray,
				requiringSecureCoding: false
			)
			return data as NSData
		} catch let error {
			LoggerImpl.shared.debug(
				"Can't archive [NewsSource] in: \(#function)",
				type: .error(error.localizedDescription)
			)
		}
		return NSData()
	}

	private func unarchiveNewsSources(from newsSourcesData: Data?) -> [NewsSource] {
		guard let data = newsSourcesData else { return [] }
		do {
			let uncarchivedSources = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
			if let sources = uncarchivedSources as? [NewsSource] {
				return sources
			} else {
				LoggerImpl.shared.debug("While unarchiving can't cast from [Any]? to [NewsSource]", type: .error(nil))
			}
		} catch let error {
			LoggerImpl.shared.debug(
				"Can't unarchive [NewsSource] from Data in: \(#function)", type: .error(error.localizedDescription)
			)
		}
		return []
	}
}
