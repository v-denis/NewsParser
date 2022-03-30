//
//  CallOnFlyOperator.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 18.03.2022.
//

import Foundation

// MARK: - * (overloaded)

@inline(__always)
@discardableResult
public func *<T>(object: T, closure: (T) -> Void) -> T {
	closure(object)
	return object
}
