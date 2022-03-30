//
//  TableView+Extensions.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 18.03.2022.
//

import UIKit

extension UITableView {
	func dequeueNewsListCell(forIndexPath indexPath: IndexPath) -> NewsListCell {
		guard let cell = dequeueReusableCell(
			withIdentifier: NewsListCell.reuseIdentifier, for: indexPath
		) as? NewsListCell
		else {
			fatalError("Can't dequeue cell:\(#file), \(#function)")
		}
		return cell
	}
}
