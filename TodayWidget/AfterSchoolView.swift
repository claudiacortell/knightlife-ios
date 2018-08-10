//
//  AfterSchoolView.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class AfterSchoolView: CustomView {
	
	@IBOutlet weak var iconImage: UIImageView!
	@IBOutlet var backgroundView: UIView!
	
	override func loadNib() {
		Bundle.main.loadNibNamed("AfterSchoolView", owner: self, options: nil)
		self.secure(view: self.backgroundView)
		
		self.iconImage.image = self.iconImage.image?.withRenderingMode(.alwaysTemplate)		
	}
	
}
