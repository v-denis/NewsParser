//
//  UIView+Extensions.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 18.03.2022.
//

import UIKit

public extension UIView {
	func addSubviews(_ views: UIView...) {
		views.forEach { self.addSubview($0) }
	}
}
