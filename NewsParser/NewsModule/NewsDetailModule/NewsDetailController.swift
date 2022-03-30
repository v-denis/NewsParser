//
//  NewsDetailController.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 22.03.2022.
//

import UIKit

final class NewsDetailController: UIViewController {
	private let newsArticle: NewsArticle

	private let scrollView = UIScrollView() * {
		$0.alwaysBounceVertical = true
		$0.showsHorizontalScrollIndicator = false
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let containerView = UIView() * {
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let titleLabel = UILabel() * {
		$0.textAlignment = .center
		$0.font = .preferredFont(forTextStyle: .title2)
		$0.textColor = .black
		$0.numberOfLines = 0
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let articleImage = UIImageView() * {
		$0.backgroundColor = .yellow
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.contentMode = .scaleAspectFit
		$0.clipsToBounds = true
	}

	private let dateLabel = UILabel() * {
		$0.textAlignment = .left
		$0.font = .preferredFont(forTextStyle: .body)
		$0.textColor = .darkGray
		$0.numberOfLines = 1
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let sourceLabel = UILabel() * {
		$0.textAlignment = .left
		$0.font = .preferredFont(forTextStyle: .body)
		$0.textColor = .darkGray
		$0.numberOfLines = 1
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	private let originalArticleLink = UITextView() * {
		$0.textAlignment = .left
		$0.font = .preferredFont(forTextStyle: .body)
		$0.textColor = .darkGray
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.isScrollEnabled = false
		$0.isSelectable = true
		$0.isEditable = false
		$0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
	}

	private let descriptionLabel = UILabel() * {
		$0.textAlignment = .natural
		$0.font = .preferredFont(forTextStyle: .body)
		$0.textColor = .black
		$0.numberOfLines = 0
		$0.translatesAutoresizingMaskIntoConstraints = false
	}

	init(newsArticle: NewsArticle) {
		self.newsArticle = newsArticle
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupContent()
		configureLayout()
	}

	// MARK: - UI

	private func configureLayout() {
		containerView.addSubviews(
			titleLabel,
			articleImage,
			dateLabel,
			sourceLabel,
			originalArticleLink,
			descriptionLabel
		)
		scrollView.addSubview(containerView)
		view.addSubviews(scrollView)

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
			titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
			titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
			titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
		])

		let imageAspectRatio: CGFloat
		if let imageHeight = articleImage.image?.size.height,
		   let imageWidth = articleImage.image?.size.width {
			imageAspectRatio = imageHeight / imageWidth
		} else {
			imageAspectRatio = 1.5
		}

		NSLayoutConstraint.activate([
			articleImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
			articleImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14),
			articleImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14),
			articleImage.heightAnchor.constraint(equalTo: articleImage.widthAnchor, multiplier: imageAspectRatio)
		])

		NSLayoutConstraint.activate([
			originalArticleLink.topAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: 14),
			originalArticleLink.leadingAnchor.constraint(equalTo: articleImage.leadingAnchor),
			originalArticleLink.trailingAnchor.constraint(equalTo: articleImage.trailingAnchor),
			originalArticleLink.heightAnchor.constraint(equalToConstant: 20)
		])

		NSLayoutConstraint.activate([
			dateLabel.topAnchor.constraint(equalTo: originalArticleLink.bottomAnchor, constant: 10),
			dateLabel.leadingAnchor.constraint(equalTo: articleImage.leadingAnchor),
			dateLabel.trailingAnchor.constraint(equalTo: articleImage.trailingAnchor),
		])

		NSLayoutConstraint.activate([
			sourceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
			sourceLabel.leadingAnchor.constraint(equalTo: articleImage.leadingAnchor),
			sourceLabel.trailingAnchor.constraint(equalTo: articleImage.trailingAnchor),
		])

		NSLayoutConstraint.activate([
			descriptionLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 34),
			descriptionLabel.leadingAnchor.constraint(equalTo: articleImage.leadingAnchor),
			descriptionLabel.trailingAnchor.constraint(equalTo: articleImage.trailingAnchor),
			descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -34),
		])
	}

	private func setupContent() {
		view.backgroundColor = .white
		title = newsArticle.source
		titleLabel.text = newsArticle.title

		if let imageData = newsArticle.imageData {
			articleImage.image = UIImage(data: imageData)
		}

		let dateText = DateFormatHelper.shared.newsDetailFormatter.string(from: newsArticle.publicationDate)
		dateLabel.text = "Дата публикации: \(dateText)"
		sourceLabel.text = "Источник: \(newsArticle.source)"

		if let sourceUrl = newsArticle.sourceUrl {
			let sourceDomain = sourceUrl.domainName()
			let attributedString = NSMutableAttributedString(string: "Оригинальная статья на \(sourceDomain)")
			attributedString.addAttributes(
				[.link: sourceUrl, .font: UIFont.preferredFont(forTextStyle: .body)],
				range: NSRange(location: 0, length: attributedString.length)
			)
			originalArticleLink.attributedText = attributedString
		} else {
			originalArticleLink.text = "Оригинальная статья отсутствует"
		}

		if newsArticle.description.isEmpty {
			descriptionLabel.text = "Описание отсутствует"
		} else {
			descriptionLabel.text = newsArticle.description
		}
	}
}
