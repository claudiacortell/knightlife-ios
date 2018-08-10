//
//  NoClassView.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class NoClassView: CustomView {
	
	@IBOutlet var backgroundView: UIView!
	
	@IBOutlet weak var iconImage: UIImageView!
	
	override func loadNib() {
		Bundle.main.loadNibNamed("NoClassView", owner: self, options: nil)
		self.secure(view: self.backgroundView)
		
		self.iconImage.image = self.iconImage.image?.withRenderingMode(.alwaysTemplate)
	}
	
}
