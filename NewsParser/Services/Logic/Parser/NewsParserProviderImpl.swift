//
//  NewsParserProviderImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

final class NewsParserProviderImpl: NewsParserProvider {
	func getParser(for data: Data, source: NewsSource) -> NewsParser {
		switch source.format {
		case .xml:
			return BasicXMLParserImpl(withXMLData: data, from: source)
		case .json:
			return NewsapiJSONParserImpl(withJSONData: data, from: source)
		}
	}
}
