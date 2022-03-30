//
//  FlowTransitions.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 27.03.2022.
//

import Foundation

enum FlowTransition {
	case asRootWindow
	case with(parent: BaseCoordinator, transition: TransitionType)
}
