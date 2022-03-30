//
//  NetworkReachabilityImpl.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 30.03.2022.
//

import Foundation
import Network

class NetworkReachabilityImpl: NetworkReachability {
	private let backgroudQueue = DispatchQueue.global(qos: .background)

	private var pathMonitor: NWPathMonitor!
	private var path: NWPath?

	lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
		self.path = path
		if path.status == NWPath.Status.satisfied {
			LoggerImpl.shared.debug("Network connected", type: .success)
		} else if path.status == NWPath.Status.unsatisfied || path.status == NWPath.Status.requiresConnection {
			LoggerImpl.shared.debug("No internet connection", type: .error(nil))
		}
	}

	init() {
		pathMonitor = NWPathMonitor()
		pathMonitor.pathUpdateHandler = self.pathUpdateHandler
		pathMonitor.start(queue: backgroudQueue)
	}

	func isNetworkAvailable() -> Bool {
		if let path = self.path {
			if path.status == NWPath.Status.satisfied {
				return true
			}
		}
		return false
	}
}
