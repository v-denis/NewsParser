//
//  IViewModeling.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 26.03.2022.
//

import Foundation

typealias InputAction<T> = (T) -> Void
typealias OutputAction<T> = (T) -> Void
typealias StepAction<T> = (T) -> Void

protocol IViewModeling {
	associatedtype Input
	associatedtype Output
	associatedtype Step

	var inputs: Input { get set }
	var outputs: Output? { get set }
	var steps: Step? { get set }
}
