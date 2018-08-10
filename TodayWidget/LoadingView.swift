//
//  LoadingView.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LoadingView: CustomView {
	
	@IBOutlet var backgroundView: UIView!
	@IBOutlet weak var backgroundStack: UIStackView!
	
	override func loadNib() {
		Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
		self.secure(view: self.backgroundView)

		UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
			self.backgroundStack.layer.opacity = 0.4
		}, completion: nil)
	}
	
}
