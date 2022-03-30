//
//  NewsSourceView.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 29.03.2022.
//

import UIKit

final class NewsSourceView: UIView {
	var newsSourceIsOn: Bool { sourceSwitch.isOn }

	private let switchAction: () -> Void

	private let sourceLabel = UILabel() * {
		$0.textAlignment = .left
		$0.font = .preferredFont(forTextStyle: .body)
		$0.textColor = .black
		$0.numberOfLines = 1
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let sourceSwitch = UISwitch() * {
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let divider = UIView() * {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.backgroundColor = .lightGray
	}

	init(
		newsSourceName: String,
		isEnabled: Bool,
		switchAction: @escaping () -> Void
	) {
		self.switchAction = switchAction
		super.init(frame: .zero)

		sourceLabel.text = newsSourceName
		sourceSwitch.setOn(isEnabled, animated: false)
		sourceSwitch.addTarget(self, action: #selector(switchStateChanged), for: .allEvents)
		configureLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureLayout() {
		self.translatesAutoresizingMaskIntoConstraints = false
		
		addSubviews(
			sourceLabel,
			sourceSwitch,
			divider
		)

		NSLayoutConstraint.activate([
			sourceSwitch.topAnchor.constraint(equalTo: self.topAnchor),
			sourceSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
		])

		NSLayoutConstraint.activate([
			sourceLabel.centerYAnchor.constraint(equalTo: sourceSwitch.centerYAnchor),
			sourceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
		])

		NSLayoutConstraint.activate([
			divider.topAnchor.constraint(equalTo: sourceSwitch.bottomAnchor, constant: 10),
			divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			divider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			divider.heightAnchor.constraint(equalToConstant: 1)
		])
	}
}

// MARK: - UI events handling

extension NewsSourceView {
	@objc private func switchStateChanged() {
		switchAction()
	}
}
