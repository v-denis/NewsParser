//
//  UIViewController+Transition.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 27.03.2022.
//

import UIKit

extension UIViewController {
	func show(withTransition transition: TransitionType) {
		switch transition {
		case .push(let root, let animated):
			guard !(self is UINavigationController) else {
				fatalError("Do not push navigationController inside other navigationController")
			}
			root.pushViewController(self, animated: animated)

		case .modal(let root, let presentationStyle, let animated):
			if let presentationStyle = presentationStyle {
				self.modalPresentationStyle = presentationStyle
			}
			root.present(self, animated: animated, completion: nil)

		case .inWindow(let window, let makeKeyWindow):
			window.rootViewController = self
			if makeKeyWindow {
				window.makeKeyAndVisible()
			}
		}
	}
}
