//
//  NewsJSONParser.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

protocol NewsJSONParser: NewsParser {
	init(withJSONData data: Data, from source: NewsSource)
}
