//
//  NewsXMLParser.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

protocol NewsXMLParser: NewsParser {
	init(withXMLData data: Data, from source: NewsSource)
}
