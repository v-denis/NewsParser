//
//  NewsParserProvider.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

protocol NewsParserProvider {
	func getParser(for data: Data, source: NewsSource) -> NewsParser
}
