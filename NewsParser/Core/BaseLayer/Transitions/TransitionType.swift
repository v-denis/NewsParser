//
//  TransitionType.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 27.03.2022.
//

import UIKit

enum TransitionType {
	case push(root: UINavigationController, animated: Bool = true)
	case modal(root: UIViewController, presentationStyle: UIModalPresentationStyle?, animated: Bool = true)
	case inWindow(window: UIWindow, makeKeyWindow: Bool)
}
