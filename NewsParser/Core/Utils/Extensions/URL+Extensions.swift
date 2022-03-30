//
//  URL+Extensions.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 22.03.2022.
//

import Foundation

extension URL {
	func domainName() -> String {
		guard let domain = self.host else {
			LoggerImpl.shared.debug(
				"Can't parse domain from URL: \(self.absoluteString)",
				type: .warning
			)
			return ""
		}
		return domain.replacingOccurrences(of: "www.", with: "")
	}
}
