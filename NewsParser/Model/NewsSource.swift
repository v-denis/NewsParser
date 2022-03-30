//
//  NewsSource.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

class NewsSource: NSObject, NSCoding {
	enum Format: String {
		case xml
		case json
	}

	let url: URL
	let format: Format
	var isEnabled: Bool

	init(
		url: URL,
		format: Format,
		isEnabled: Bool = true
	) {
		self.url = url
		self.format = format
		self.isEnabled = isEnabled
	}

	// MARK: - NSCoding

	required init(coder aDecoder: NSCoder) {
		isEnabled = aDecoder.decodeBool(forKey: .sourceEnabledKey)
		guard let url = aDecoder.decodeObject(forKey: .sourceUrlKey) as? URL,
			  let formatRawValue = aDecoder.decodeObject(forKey: .sourceFormatKey) as? String,
			  let format = Format(rawValue: formatRawValue) else {
				  fatalError("Can't decode NewsSource by NSCoder in \(#function)")
			  }
		self.url = url
		self.format = format
	}

	func encode(with coder: NSCoder) {
		coder.encode(url, forKey: .sourceUrlKey)
		coder.encode(format.rawValue, forKey: .sourceFormatKey)
		coder.encode(isEnabled, forKey: .sourceEnabledKey)
	}
}

extension String {
	fileprivate static var sourceUrlKey: String { "sourceUrl" }
	fileprivate static var sourceFormatKey: String { "sourceFormat" }
	fileprivate static var sourceEnabledKey: String { "sourceIsEnabled" }
}

// MARK: - Default news sources

extension NewsSource {
	static var defaultSources: [NewsSource] {
		[vedomosti, lenta, newsapi].compactMap { $0 }
	}

	static var vedomosti: NewsSource? {
		guard let vedomostiUrl = URL(string: "https://www.vedomosti.ru/rss/articles") else {
			LoggerImpl.shared.debug(
				"Can't get URL for \"vedomosti.ru\" from string path in: \(#file)",
				type: .error(nil)
			)
			return nil
		}
		return NewsSource(url: vedomostiUrl, format: .xml)
	}

	static var lenta: NewsSource? {
		guard let lentaUrl = URL(string: "https://lenta.ru/rss/news") else {
			LoggerImpl.shared.debug(
				"Can't get URL for \"lenta.ru\" from string path in: \(#file)",
				type: .error(nil)
			)
			return nil
		}
		return NewsSource(url: lentaUrl, format: .xml)
	}

	static var newsapi: NewsSource? {
		guard let newsApiUrl = URL(
			string: "https://newsapi.org/v2/top-headlines?country=ru&apiKey=6e95ede4af75477495d19294bf4cc95e"
		)
		else {
			LoggerImpl.shared.debug(
				"Can't get URL for \"newsapi.org\" from string path in: \(#file)",
				type: .error(nil)
			)
			return nil
		}
		return NewsSource(url: newsApiUrl, format: .json)
	}
}

// MARK: - Equatable

extension NewsSource {
	/// Check with `isEnabled` property
	static func == (lhs: NewsSource, rhs: NewsSource) -> Bool {
		return lhs.url == rhs.url && lhs.format == rhs.format
	}

	/// Check without `isEnabled` property
	static func != (lhs: NewsSource, rhs: NewsSource) -> Bool {
		return lhs.url != rhs.url || lhs.format != rhs.format || lhs.isEnabled != rhs.isEnabled
	}
}
