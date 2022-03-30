//
//  AppDelegate.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 18.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	let app = NewsParserApp()
	let orientationLock: UIInterfaceOrientationMask = .portrait

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		if #available(iOS 13.0, *) {
			// In iOS 13 setup is done in SceneDelegate
		} else {
			window?.makeKeyAndVisible()
		}
		return true
	}

	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		if #available(iOS 13.0, *) {
			// In iOS 13 setup is done in SceneDelegate
		} else {
			window = UIWindow(frame: UIScreen.main.bounds)
			app.startApp(inWindow: window!)
		}
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		orientationLock
	}
}

