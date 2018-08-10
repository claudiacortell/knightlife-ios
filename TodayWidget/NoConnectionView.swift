//
//  NoConnectionView.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class NoConnectionView: CustomView {
	
	@IBOutlet var backgroundView: UIView!
	
	override func loadNib() {
		Bundle.main.loadNibNamed("NoConnectionView", owner: self, options: nil)
		self.secure(view: self.backgroundView)
	}
	
}
