//
//  ImageProvider.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 21.03.2022.
//

import UIKit

protocol ImageProvider {
	func getImageData(from url: URL) async -> Data?
	
	func getDummyImageData() -> Data
}
