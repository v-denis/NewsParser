//
//  NewsapiJSONParserImplTests.swift
//  NewsParserTests
//
//  Created by Denis Valshchikov on 31.03.2022.
//

import XCTest
@testable import NewsParser

class NewsapiJSONParserImplTests: XCTestCase {
	private lazy var sut = NewsapiJSONParserImpl(withJSONData: jsonData, from: newsSource)

	private var jsonData = Data()
	private var newsSource = NewsSource(url: URL(string: "test.ru")!, format: .json)

	func test_ParseNews_ReturnsJsonNewsArticleWithCorrectParams() throws {
		self.jsonData = Env.json.data(using: .utf8)!
		let expectArticle = JsonNewsArticle(
			source: JsonNewsArticle.Source(name: "Sakhalin.info"),
			author: nil,
			title: "Сбербанк отменяет одобренную ипотеку по прежним ставкам - Sakhalin news",
			description: "Лидер рынка ипотечного кредитования в России Сбербанк пошел на непопулярный, но экономически обоснованный шаг — отменил все одобренные на прежних условиях ипотечные заявки, по которым кредитные договоры не были подписаны до 30 марта включительно. Новые ус...",
			url: "https://sakhalin.info/news/219318",
			urlToImage: "https://i.sakh.com/info/p/photos/219/219318/ff83142b8b62f767f4292f227013227abc63cbf65.jpg",
			publishedAt: "2022-03-30T21:13:00Z",
			content: "aaa",
			jsonSource: newsSource.url
		)

		let articles = try sut.parseNews()

		XCTAssertTrue(articles.count == 1)
		XCTAssertTrue(articles is [JsonNewsArticle])
		XCTAssertEqual((articles.first as? JsonNewsArticle)?.title, expectArticle.title)
		XCTAssertEqual((articles.first as? JsonNewsArticle)?.url, expectArticle.url)
		XCTAssertEqual((articles.first as? JsonNewsArticle)?.description, expectArticle.description)
		XCTAssertEqual((articles.first as? JsonNewsArticle)?.urlToImage, expectArticle.urlToImage)
	}
}


extension NewsapiJSONParserImplTests {
	private struct Env {
		static let json = """
{
  "articles": [
	{
	  "source": {
		"id": null,
		"name": "Sakhalin.info"
	  },
	  "author": null,
	  "title": "Сбербанк отменяет одобренную ипотеку по прежним ставкам - Sakhalin news",
	  "description": "Лидер рынка ипотечного кредитования в России Сбербанк пошел на непопулярный, но экономически обоснованный шаг — отменил все одобренные на прежних условиях ипотечные заявки, по которым кредитные договоры не были подписаны до 30 марта включительно. Новые ус...",
	  "url": "https://sakhalin.info/news/219318",
	  "urlToImage": "https://i.sakh.com/info/p/photos/219/219318/ff83142b8b62f767f4292f227013227abc63cbf65.jpg",
	  "publishedAt": "2022-03-30T21:13:00Z",
	  "content": "aaa"
	}
  ]
}
"""
	}
}
