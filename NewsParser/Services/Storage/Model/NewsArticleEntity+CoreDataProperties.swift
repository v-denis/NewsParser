//
//  NewsArticleEntity+CoreDataProperties.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 25.03.2022.
//
//

import Foundation
import CoreData


extension NewsArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsArticleEntity> {
        return NSFetchRequest<NewsArticleEntity>(entityName: "NewsArticleEntity")
    }

    @NSManaged public var articleId: UUID?
    @NSManaged public var descriptionText: String?
    @NSManaged public var imageUrl: URL?
    @NSManaged public var isOpened: Bool
    @NSManaged public var publicationDate: Date?
    @NSManaged public var source: String?
    @NSManaged public var sourceUrl: URL?
    @NSManaged public var title: String?
    @NSManaged public var imageData: Data?

}

extension NewsArticleEntity : Identifiable {

}
