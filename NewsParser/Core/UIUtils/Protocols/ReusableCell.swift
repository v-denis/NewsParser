//
//  ReusableCell.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 18.03.2022.
//

import UIKit

public protocol ReusableCell: AnyObject {
	static var reuseIdentifier: String { get }
}

public extension ReusableCell {
	static var reuseIdentifier: String { "\(Self.self)" }
}

extension UITableViewCell: ReusableCell {}

public extension UITableView {
	func register<Cell>(_ cellClass: Cell.Type) where Cell: ReusableCell {
		register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
	}
}
