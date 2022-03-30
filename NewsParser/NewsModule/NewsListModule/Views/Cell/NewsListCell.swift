//
//  NewsListCell.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 18.03.2022.
//

import UIKit

final class NewsListCell: UITableViewCell {
	private let leadingStackView = UIStackView() * {
		$0.alignment = .leading
		$0.axis = .vertical
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let titleLabel = UILabel() * {
		$0.textAlignment = .left
		$0.font = .preferredFont(forTextStyle: .body)
		$0.textColor = .black
		$0.numberOfLines = 2
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let sourceLabel = UILabel() * {
		$0.textAlignment = .left
		$0.font = .preferredFont(forTextStyle: .footnote)
		$0.textColor = .darkGray
		$0.numberOfLines = 1
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.text = "Источник отсутствует"
	}

	private let articleImage = UIImageView() * {
		$0.backgroundColor = Constants.backgroundColor
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.contentMode = .scaleAspectFill
		$0.clipsToBounds = true
	}

	private let openedContainer = UIView() * {
		$0.backgroundColor = .black
		$0.layer.cornerRadius = 12
		$0.isHidden = true
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let openedLabel = UILabel() * {
		$0.text = "Просмотрено 👀"
		$0.font = .preferredFont(forTextStyle: .footnote)
		$0.textColor = .white
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		articleImage.image = nil
		titleLabel.text = nil
		openedContainer.isHidden = true
		articleImage.alpha = 1.0
		leadingStackView.alpha = 1.0
		sourceLabel.text = "Источник отсутствует"
	}

	// MARK: - UI

	private func configureUI() {
		backgroundColor = Constants.backgroundColor

		openedContainer.addSubview(openedLabel)

		leadingStackView.addSubviews(
			titleLabel,
			sourceLabel
		)

		contentView.addSubviews(
			articleImage,
			leadingStackView,
			openedContainer
		)

		NSLayoutConstraint.activate([
			articleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			articleImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
			articleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
			articleImage.widthAnchor.constraint(equalTo: articleImage.heightAnchor, multiplier: 1.5),
		])

		NSLayoutConstraint.activate([
			leadingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			leadingStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			leadingStackView.trailingAnchor.constraint(equalTo: articleImage.leadingAnchor, constant: -12),
			leadingStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
			leadingStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
		])

		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingStackView.leadingAnchor),
			titleLabel.topAnchor.constraint(equalTo: leadingStackView.topAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: leadingStackView.trailingAnchor),
		])

		NSLayoutConstraint.activate([
			sourceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			sourceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			sourceLabel.bottomAnchor.constraint(equalTo: leadingStackView.bottomAnchor),
			sourceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
		])

		NSLayoutConstraint.activate([
			openedLabel.topAnchor.constraint(equalTo: openedContainer.topAnchor, constant: 5),
			openedLabel.bottomAnchor.constraint(equalTo: openedContainer.bottomAnchor, constant: -5),
			openedLabel.leadingAnchor.constraint(equalTo: openedContainer.leadingAnchor, constant: 8),
			openedLabel.trailingAnchor.constraint(equalTo: openedContainer.trailingAnchor, constant: -8),
		])

		NSLayoutConstraint.activate([
			openedContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
			openedContainer.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
		])

		openedContainer.setContentHuggingPriority(.defaultLow, for: .horizontal)
		openedContainer.setContentHuggingPriority(.defaultLow, for: .vertical)
	}
}

// MARK: - Configuring

extension NewsListCell {
	func configure(with newsArticle: NewsArticle) {
		self.titleLabel.text = newsArticle.title
		self.sourceLabel.text = "Источник: \(newsArticle.source)"
		if let imageData = newsArticle.imageData,
		   let image = UIImage(data: imageData) {
			articleImage.image = image
		}

		if newsArticle.isOpened {
			openedContainer.isHidden = false
			articleImage.alpha = 0.6
			leadingStackView.alpha = 0.6
		} else {
			openedContainer.isHidden = true
			articleImage.alpha = 1.0
			leadingStackView.alpha = 1.0
		}
	}

}

// MARK: - Constants

extension NewsListCell {
	private struct Constants {
		static var titleHorizontalOffsets: CGFloat { 12.0 }
		static var imageVerticalOffsets: CGFloat { 5.0 }
		static var imageWidthMultiplier: CGFloat { 1.5 }
		static var backgroundColor: UIColor { UIColor(red: 0.99, green: 0.99, blue: 0.95, alpha: 1) }
	}
}
