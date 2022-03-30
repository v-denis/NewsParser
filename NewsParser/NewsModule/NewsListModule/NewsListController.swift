//
//  NewsViewController.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 18.03.2022.
//

import CoreData
import UIKit

final class NewsListController: UIViewController {
	let viewModel: ViewModel

	private let newsTableView = NewsListTableView(frame: .zero, style: .plain)

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		setupViewModelOutput()
		setupTableView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		configureContent()
		configureLayout()
    }

	@objc private func rightBarButtonAction(_ sender: UIBarButtonItem) {
		viewModel.inputs.settingsButtonTap(())
	}

	// MARK: - UI

	private func configureLayout() {
		view.addSubview(newsTableView)

		newsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		newsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		newsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}

	private func configureContent() {
		title = Constants.viewTitle
		view.backgroundColor = .white

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "gear"),
			style: .plain,
			target: self,
			action: #selector(rightBarButtonAction(_:))
		)
	}

	private func setupViewModelOutput() {
		viewModel.outputs = ViewModel.Output(
			reloadTableView: { [weak self] in
				self?.newsTableView.reloadData()
			},
			reloadNewsArticleCell: { [weak self] indexPath in
				self?.newsTableView.reloadRows(at: [indexPath], with: .fade)
			}
		)
	}

	private func setupTableView() {
		newsTableView.dataSource = viewModel.tableViewDataSource
		newsTableView.delegate = viewModel.tableViewDataSource
	}
}

// MARK: - IViewModelOwner

extension NewsListController: IViewModelOwner {
	typealias ViewModel = NewsListViewModel
}

// MARK: - Constants

extension NewsListController {
	private struct Constants {
		static var viewTitle: String { "Новости" }
	}
}
