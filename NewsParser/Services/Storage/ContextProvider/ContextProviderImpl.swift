//
//  ContextProviderImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 30.03.2022.
//

import CoreData
import Foundation

final class ContextProviderImpl: ContextProvider {
	lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
	lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()

	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "NewsParser")
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error as NSError? {
				LoggerImpl.shared.debug(
					"Can't loads the persistent stores by NSPersistentContainer!",
					type: .error(error.localizedDescription)
				)
			}
		}
		return container
	}()
}
