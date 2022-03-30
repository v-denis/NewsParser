//
//  ImageProviderImplTests.swift
//  NewsParserTests
//
//  Created by Denis Valshchikov on 31.03.2022.
//

import XCTest
@testable import NewsParser

class ImageProviderImplTests: XCTestCase {
	private lazy var sut = ImageProviderImpl(networkService: networkService)

	private let networkService = NetworkServiceMock()

	func test_GetImageData_WhenNetworkServiceSuccessfullyFetchData_ReturnsCorrectImageData() async {
		let imageData = UIImage(systemName: "pc")!.pngData()
		networkService.debugImageData = imageData

		let resultData = await sut.getImageData(from: URL(string: "www.test.ru")!)

		XCTAssertEqual(imageData, resultData)
	}

	func test_GetImageData_WhenNetworkServiceDoesNotFetchData_ReturnsEmptyData() async {
		networkService.debugImageData = nil

		let resultData = await sut.getImageData(from: URL(string: "www.test.ru")!)

		XCTAssertEqual(resultData, Data())
	}

	func test_GetImageData_WhenNetworkServiceThrowsError_ReturnsImageDataEqualNil() async {
		networkService.debugFetchError = TestError.mock

		let resultData = await sut.getImageData(from: URL(string: "wwww.test.ru")!)

		XCTAssertEqual(resultData, nil)
	}

	func test_GetDummyImageData_ReturnsDataOfAssetsImage() {
		let dummyImageData = UIImage(named: "no-image")!.jpegData(compressionQuality: 0.9)!

		let resultData = sut.getDummyImageData()

		XCTAssertEqual(dummyImageData, resultData)
	}
}
