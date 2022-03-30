//
//  ImageProviderImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 21.03.2022.
//

import UIKit

final class ImageProviderImpl: ImageProvider {
	private let networkService: NetworkService

	init(networkService: NetworkService) {
		self.networkService = networkService
	}

	func getImageData(from url: URL) async -> Data? {
		do {
			let imageData = try await networkService.fetchDataImage(from: url)
			return imageData
		} catch let error {
			LoggerImpl.shared.debug(
				"Can't fetch ImageData from: \(url.absoluteString)",
				type: .error(error.localizedDescription)
			)
			return nil
		}
	}

	func getDummyImageData() -> Data {
		if let dummyImage = UIImage(named: "no-image"),
		   let dummyImageData = dummyImage.jpegData(compressionQuality: 0.9) {
			return dummyImageData
		} else {
			LoggerImpl.shared.debug(
				"Can't get Dummy Image Data in: \(#function)",
				type: .error(nil)
			)
			return Data()
		}
	}
}
