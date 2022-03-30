//
//  SettingsController.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 22.03.2022.
//

import UIKit

final class SettingsController: UIViewController {
	private static var pickerViewNumberOfComponents: Int { 1 }

	let viewModel: ViewModel

	private let scrollView = UIScrollView() * {
		$0.alwaysBounceVertical = true
		$0.showsHorizontalScrollIndicator = false
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.delaysContentTouches = false
	}

	private let containerView = UIView() * {
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let titleLabel = UILabel() * {
		$0.textAlignment = .center
		$0.font = .boldSystemFont(ofSize: 20)
		$0.textColor = .black
		$0.numberOfLines = 3
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.text = "Частота обновления новостей"
	}

	private let timeIntervalPickerView = UIPickerView() * {
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let subtitleLabel = UILabel() * {
		$0.textAlignment = .center
		$0.font = .boldSystemFont(ofSize: 20)
		$0.textColor = .black
		$0.numberOfLines = 1
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.text = "Источники новостей"
	}

	private let newsSourcesStack = UIStackView() * {
		$0.alignment = .fill
		$0.distribution = .equalSpacing
		$0.axis = .vertical
		$0.spacing = 20
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let saveButton = ButtonWithState(type: .system) * {
		$0.setTitle("Сохранить", for: .normal)
		$0.setTitleColor(.white, for: .normal)
		$0.backgroundColor = .black
		$0.layer.cornerRadius = 20
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private var newsSourcesViews = [(source: NewsSource, view: NewsSourceView)]()

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		timeIntervalPickerView.dataSource = self
		timeIntervalPickerView.delegate = self
		setupContent()
		configureLayout()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let selectedRow = viewModel.availableTimeIntervals.firstIndex(of: viewModel.fetchedTimeInterval) {
			timeIntervalPickerView.selectRow(
				selectedRow,
				inComponent: Self.pickerViewNumberOfComponents - 1,
				animated: false
			)
		}
	}

	private func setupContent() {
		view.backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.95, alpha: 1)
		saveButton.isEnabled = false

		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		containerView.addSubviews(
			titleLabel,
			timeIntervalPickerView,
			subtitleLabel,
			newsSourcesStack,
			saveButton
		)

		viewModel.fetchedNewsSources.forEach {
			let newsSourceView = NewsSourceView(
				newsSourceName: $0.url.domainName(),
				isEnabled: $0.isEnabled,
				switchAction: { [weak self] in self?.saveButton.isEnabled = true }
			)
			newsSourcesViews.append(
				($0, newsSourceView)
			)
			newsSourcesStack.addArrangedSubview(newsSourceView)
		}

		saveButton.addTarget(
			self,
			action: #selector(saveButtonTapAction(_:)),
			for: .touchUpInside
		)
	}

	private func configureLayout() {
		NSLayoutConstraint.activate([
			scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
			scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
		])

		NSLayoutConstraint.activate([
			scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: containerView.heightAnchor),
			scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
			scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
		])

		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
			containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
			containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
		])

		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
			titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
			titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
		])

		NSLayoutConstraint.activate([
			timeIntervalPickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
			timeIntervalPickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
			timeIntervalPickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
		])

		NSLayoutConstraint.activate([
			subtitleLabel.topAnchor.constraint(equalTo: timeIntervalPickerView.bottomAnchor, constant: 12),
			subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
		])

		NSLayoutConstraint.activate([
			newsSourcesStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
			newsSourcesStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
			newsSourcesStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
		])

		NSLayoutConstraint.activate([
			saveButton.topAnchor.constraint(equalTo: newsSourcesStack.bottomAnchor, constant: 70),
			saveButton.heightAnchor.constraint(equalToConstant: 40),
			saveButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
			saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
		])
	}
}

// MARK: - UI events handling

extension SettingsController {
	@objc private func saveButtonTapAction(_ button: UIButton) {
		let editedNewsSources = newsSourcesViews.map {
			NewsSource(
				url: $0.source.url,
				format: $0.source.format,
				isEnabled: $0.view.newsSourceIsOn
			)
		}
		let component = Self.pickerViewNumberOfComponents - 1
		guard timeIntervalPickerView.selectedRow(inComponent: component) != -1 else { return }

		let selectedRow = timeIntervalPickerView.selectedRow(inComponent: component)
		let timeInterval = viewModel.availableTimeIntervals[selectedRow]

		let userSettings = UserSettings(
			newsSources: editedNewsSources,
			newsUpdateTimeInterval: timeInterval
		)
		viewModel.inputs.saveButtonTap(userSettings)
		saveButton.isEnabled = false
	}
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension SettingsController: UIPickerViewDataSource, UIPickerViewDelegate {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		Self.pickerViewNumberOfComponents
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return viewModel.availableTimeIntervals.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if viewModel.availableTimeIntervals[row] == 0 {
			return "никогда"
		}
		return "каждые \(viewModel.availableTimeIntervals[row]) секунд"
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		saveButton.isEnabled = true
	}
}

// MARK: - IViewModelOwner

extension SettingsController: IViewModelOwner {
	typealias ViewModel = SettingsViewModel
}
