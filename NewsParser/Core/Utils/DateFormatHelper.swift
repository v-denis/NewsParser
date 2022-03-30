//
//  DateFormatHelper.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 30.03.2022.
//

import Foundation

final class DateFormatHelper {
	static let shared = DateFormatHelper()

	lazy var newsDetailFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "d MMMM, HH:mm"
		formatter.locale = Locale.init(identifier: "ru_RU")
		return formatter
	}()

	lazy var xmlDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
		return formatter
	}()

	lazy var jsonDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return formatter
	}()
}
