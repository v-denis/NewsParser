//
//  NewsArticleDeserializable.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 22.03.2022.
//

import Foundation

protocol NewsArticleDeserializable {
	func makeNewsArticle() -> NewsArticle
}
