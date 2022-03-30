//
//  UserDefaultsManagerTests.swift
//  NewsParserTests
//
//  Created by Denis Valshchikov on 31.03.2022.
//

import XCTest
@testable import NewsParser

class UserDefaultsManagerTests: XCTestCase {
	private lazy var sut = UserDefaultsManager(userDefaults: standartUserDefaults)

	private let standartUserDefaults = UserDefaults.standard

	func test_SetObject_WhenKeyTimeInterval_SetsCorrectValueToUserDefaults() {
		let key = UserDefaultsManager.Keys.timerInterval

		sut.setObject(42, forKey: key)

		XCTAssertTrue(
			standartUserDefaults.object(forKey: key.rawValue) as? Int == 42
		)
	}

	func test_SetObject_WhenKeyFirstLaunch_SetsCorrectValueToUserDefaults() {
		let key = UserDefaultsManager.Keys.firstLaunch
		let value = true

		sut.setObject(value, forKey: key)

		XCTAssertEqual(value, standartUserDefaults.bool(forKey: key.rawValue))
	}

	func test_SetObject_WhenKeyNewsSources_SetsCorrectValueToUserDefaults() {
		let key = UserDefaultsManager.Keys.newsSources
		let sources = [NewsSource(url: URL(string: "www.test.ru")!, format: .xml, isEnabled: true)]

		sut.setObject(sources, forKey: key)

		let data = standartUserDefaults.object(forKey: key.rawValue) as? Data
		let unarchivedSources = unarchiveNewsSources(from: data)
		XCTAssertEqual(unarchivedSources.count, 1)
		XCTAssertEqual(sources.count, unarchivedSources.count)
		XCTAssertEqual(sources.first?.url, unarchivedSources.first?.url)
		XCTAssertEqual(sources.first?.format, unarchivedSources.first?.format)
		XCTAssertEqual(sources.first?.isEnabled, unarchivedSources.first?.isEnabled)
	}

	func test_GetObject_WhenTimeIntervalKey_ReceivesCorrectValue() {
		let key = UserDefaultsManager.Keys.timerInterval
		standartUserDefaults.set(11, forKey: key.rawValue)

		let object = sut.getObject(forKey: key)

		XCTAssertEqual(object as? Int, 11)
	}

	func test_GetObject_WhenFirstLaunchKey_ReceivesCorrectValue() {
		let key = UserDefaultsManager.Keys.firstLaunch
		standartUserDefaults.set(false, forKey: key.rawValue)

		let object = sut.getObject(forKey: key)

		XCTAssertEqual(object as? Bool, false)
	}

	func test_GetObject_WhenNewsSourcesKey_ReceivesCorrectArchivedValue() {
		let key = UserDefaultsManager.Keys.newsSources
		let testSources = [NewsSource(url: URL(string: "www.test.ru")!, format: .json, isEnabled: false)]
		let archivedSources = archiveNewsSources(testSources)
		standartUserDefaults.set(archivedSources, forKey: key.rawValue)

		let objects = sut.getObject(forKey: key) as? [NewsSource]

		XCTAssertEqual(objects?.count, 1)
		XCTAssertEqual(objects?.count, testSources.count)
		XCTAssertEqual(objects?.first?.url, testSources.first?.url)
		XCTAssertEqual(objects?.first?.format, testSources.first?.format)
		XCTAssertEqual(objects?.first?.isEnabled, testSources.first?.isEnabled)
	}
}

// MARK: - Helpers
extension UserDefaultsManagerTests {
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
