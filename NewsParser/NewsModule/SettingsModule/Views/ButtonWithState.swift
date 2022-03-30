//
//  Button.swift
//  NewsParser
//
//  Created by Denis Valshchikov on 29.03.2022.
//

import UIKit

final class ButtonWithState: UIButton {
	override var isEnabled: Bool {
		didSet {
			setupAlpha(forState: isEnabled)
		}
	}

	private func setupAlpha(forState isEnabled: Bool) {
		if isEnabled {
			alpha = 1.0
		} else {
			alpha = 0.4
		}
	}
}
