//
//  NewsParserApp.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 27.03.2022.
//

import UIKit

final class NewsParserApp {
	private let appCoordinator = AppCoordinator(parentCoordinator: nil)

	private var window: UIWindow?

	init() {}
}

// MARK: - App life cycle

extension NewsParserApp {
	func startApp(inWindow window: UIWindow) {
		self.window = window
		configureWindowUI(window)
		appCoordinator.start(withTransition: .inWindow(window: window, makeKeyWindow: true))
	}

	private func configureWindowUI(_ window: UIWindow) {
		window.backgroundColor = .white

		/// App does not support dark theme yet. Override theme to avoid unappropriate appearance in native elements.
		if #available(iOS 13.0, *) {
			window.overrideUserInterfaceStyle = .light;
		}
	}
}
