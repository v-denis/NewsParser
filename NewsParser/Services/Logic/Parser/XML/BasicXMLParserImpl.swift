//
//  NewsXMLParserImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 20.03.2022.
//

import Foundation

class BasicXMLParserImpl: NSObject, NewsXMLParser {
	private let newsSource: NewsSource

	private var xmlParser: XMLParser
	private var parsedNews: [XmlNewsArticle] = []
	private var xmlText = ""
	private var currentArticle: XmlNewsArticle?

	required init(withXMLData data: Data, from source: NewsSource) {
		self.newsSource = source
		xmlParser = XMLParser(data: data)
	}

	func parseNews() -> [NewsArticleDeserializable] {
		xmlParser.delegate = self
		xmlParser.parse()
		return parsedNews
	}
}

// MARK: - XMLParserDelegate

extension BasicXMLParserImpl: XMLParserDelegate {
	private enum ParsingKeys: String {
		case title
		case link
		case enclosure
		case enclosureUrl = "url"
		case enclosureFormat = "type"
		case category
		case description
		case pubDate
		case item
	}

	private var formattedXmlText: String {
		xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}

	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] =  [:]
	) {
		xmlText = ""

		switch elementName {
		case ParsingKeys.item.rawValue:
			currentArticle = XmlNewsArticle(xmlSource: newsSource.url)

		case ParsingKeys.enclosure.rawValue:
			if let enclosureUrlText = attributeDict[ParsingKeys.enclosureUrl.rawValue] {
				currentArticle?.enclosureUrl = enclosureUrlText
			}
			if let enclosureUrlType = attributeDict[ParsingKeys.enclosureFormat.rawValue] {
				currentArticle?.enclosureType = enclosureUrlType
			}
		default:
			// Can be logged for some skipped tags for example.
			break
		}
	}

	func parser(
		_ parser: XMLParser,
		didEndElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?)
	{
		switch elementName {
		case ParsingKeys.title.rawValue:
			currentArticle?.title = formattedXmlText
		case ParsingKeys.link.rawValue:
			currentArticle?.sourceLink = formattedXmlText
		case ParsingKeys.description.rawValue:
			currentArticle?.description = formattedXmlText
		case ParsingKeys.pubDate.rawValue:
			currentArticle?.publicationDate = formattedXmlText
		case ParsingKeys.category.rawValue:
			currentArticle?.category = formattedXmlText
		case ParsingKeys.item.rawValue:
			if let newArticle = currentArticle {
				parsedNews.append(newArticle)
			}
		default:
			// Can be logged for some skipped tags for example.
			break
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		xmlText += string
	}
}
