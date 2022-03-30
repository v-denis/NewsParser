//
//  NewsTableView.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 18.03.2022.
//

import UIKit

final class NewsListTableView: UITableView {
	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)
		setupContent()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupContent() {
		translatesAutoresizingMaskIntoConstraints = false
		contentInset = Constants.contentInset
		if #available(iOS 13.0, *) {
			automaticallyAdjustsScrollIndicatorInsets = true
		}
		allowsSelection = true
		allowsMultipleSelection = false
		delaysContentTouches = false
		contentInsetAdjustmentBehavior = .always
		showsHorizontalScrollIndicator = false
		rowHeight = Constants.rowsHeight

		register(NewsListCell.self)
	}
}

// MARK: - Constants

extension NewsListTableView {
	private struct Constants {
		static var rowsHeight: CGFloat { 80.0 }
		static var contentInset: UIEdgeInsets { .zero }
	}
}
