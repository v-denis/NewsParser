//
//  NetworkReachability.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 30.03.2022.
//

import Foundation

protocol NetworkReachability {
	func isNetworkAvailable() -> Bool
}
