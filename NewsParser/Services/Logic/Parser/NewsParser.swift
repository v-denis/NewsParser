//
//  NewsParser.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

protocol NewsParser {
	func parseNews() throws -> [NewsArticleDeserializable]
}
