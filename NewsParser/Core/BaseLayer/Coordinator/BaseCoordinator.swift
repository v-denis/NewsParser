//
//  BaseCoordinator.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 27.03.2022.
//

import Foundation

open class BaseCoordinator {
	private(set) weak var parentCoordinator: BaseCoordinator?
	private(set) var childCoordinators = [BaseCoordinator]()

	init(parentCoordinator: BaseCoordinator?) {
		self.parentCoordinator = parentCoordinator
	}

	func add(dependency coordinator: BaseCoordinator) {
		childCoordinators.append(coordinator)
	}

	func removeAllDependencies() {
		childCoordinators.removeAll()
	}

	func remove(dependency coordinator: BaseCoordinator) {
		childCoordinators.removeAll(where: { $0 === coordinator })
	}

	func start(withTransition transition: TransitionType) {
		fatalError("start(withTransition:) needs to be overriden")
	}

	func finish(with completion: @escaping () -> Void) {
		childCoordinators.forEach { $0.parentCoordinator = nil }
		parentCoordinator?.remove(dependency: self)
		completion()
	}
}
