//
//  LoggerImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 23.03.2022.
//

import Foundation

final class LoggerImpl {
	static let shared = LoggerImpl()

	func debug(_ message: String, type: LogMessageType) {
		switch type {
		case let .error(errorText) where errorText != nil:
			print("[\(type.associatedSign)] \(message) Error info: \(errorText!)")
		case .warning,
			 .success,
			 .info,
			 .error:
			print("[\(type.associatedSign)] \(message)")
		}
	}
}

extension LoggerImpl {
	enum LogMessageType {
		case error(_ errorText: String? = nil)
		case warning
		case info
		case success

		var associatedSign: String {
			switch self {
			case .error:
				return "❌"
			case .warning:
				return "⚠️"
			case .info:
				return "ℹ️"
			case .success:
				return "✅"
			}
		}
	}
}
