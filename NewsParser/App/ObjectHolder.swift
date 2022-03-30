//
//  ObjectHolder.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 28.03.2022.
//

import Foundation


protocol ObjectHolder: AnyObject {
	var newsUpdateService: NewsUpdateService { get }
	var storageManager: StorageManager { get }
	var networkService: NetworkService { get }
	var newsParserProvider: NewsParserProvider { get }
	var newsSourcesProvider: NewsSourcesProvider { get }
	var settingsManager: SettingsManager { get }
	var newsUpdateCaller: NewsUpdateCaller { get }
	var contextProvider: ContextProvider { get }
}
