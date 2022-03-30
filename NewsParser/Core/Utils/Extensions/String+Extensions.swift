//
//  String+Extensions.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 22.03.2022.
//

import Foundation

extension String {
	func makeUrl() -> URL? {
		guard let resultUrl = URL(string: self) else {
			LoggerImpl.shared.debug(
				"Can't create URL from String: \(self.description). isEmpty = \(self.isEmpty)",
				type: .warning
			)
			return nil
		}
		return resultUrl
	}
}

extension String {
	func getDate(newsSourceFormat: NewsSource.Format) -> Date {
		let dateFormatter: DateFormatter
		switch newsSourceFormat {
		case .json:
			dateFormatter = DateFormatHelper.shared.jsonDateFormatter
		case .xml:
			dateFormatter = DateFormatHelper.shared.xmlDateFormatter
		}
		guard let resultDate = dateFormatter.date(from: self)
		else {
			LoggerImpl.shared.debug(
				"Can't parse correct date from String: \(self) with in: \(#function)",
				type: .warning
			)
			return Date()
		}
		return resultDate
	}
}
