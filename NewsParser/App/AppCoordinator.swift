//
//  AppCoordinator.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 27.03.2022.
//

import Foundation

internal final class AppCoordinator: BaseCoordinator {
	internal private(set) var startTransition: TransitionType! // `!` because we are sure to start this coordinator

	override func start(withTransition transition: TransitionType) {
		self.startTransition = transition
		open(.newsList, transition: .asRootWindow)
	}

	override func finish(with completion: @escaping () -> Void) {
		fatalError("Can't finish AppCoordinator. It is a root coordinator to rule them all")
	}
}

// MARK: - Flows

extension AppCoordinator {
	func open(_ flow: Flow, transition flowTransition: FlowTransition) {
		let (parent, transition) = prepare(flowTransition)
		func openCoordinator(_ coordinator: BaseCoordinator) {
			coordinator.start(withTransition: transition)
			parent.add(dependency: coordinator)
		}
		switch flow {
		case .newsList:
			let newsCoordinator = NewsModuleCoordinator(parentCoordinator: parent)
			openCoordinator(newsCoordinator)
		}
	}
}

// MARK: - Helpers

private extension AppCoordinator {

	func prepare(_ flowTransition: FlowTransition) -> (BaseCoordinator, TransitionType) {
		if case .asRootWindow = flowTransition { removeAllDependencies() }
		return (self.parent(from: flowTransition), self.transition(from: flowTransition))
	}

	private func parent(from flowTransition: FlowTransition) -> BaseCoordinator {
		switch flowTransition {
		case .asRootWindow:
			return self
		case .with(let parent, _):
			return parent
		}
	}

	private func transition(from flowTransition: FlowTransition) -> TransitionType {
		switch flowTransition {
		case .asRootWindow:
			return startTransition
		case .with(_, let transition):
			return transition
		}
	}
}
