//
//  ContextProvider.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 30.03.2022.
//

import CoreData

protocol ContextProvider {
	var viewContext: NSManagedObjectContext { get }
	var backgroundContext: NSManagedObjectContext { get }
}
