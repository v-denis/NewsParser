//
//  IViewModelOwner.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 26.03.2022.
//

import Foundation

protocol IViewModelOwner {
	associatedtype ViewModel: IViewModeling

	var viewModel: ViewModel { get }
}
