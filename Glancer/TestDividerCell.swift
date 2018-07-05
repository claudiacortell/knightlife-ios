//
//  TestDividerCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/23/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class TestDividerCell: UITableViewCell {
	
	var indentLeft: Float = 15.0 {
		didSet {
			self.leadingConstraint.constant = CGFloat(self.indentLeft)
		}
	}
	var indentRight: Float = 15.0 {
		didSet {
			self.trailingConstraint.constant = CGFloat(self.indentRight)
		}
	}
	
	@IBOutlet weak var leadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var trailingConstraint: NSLayoutConstraint!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.leadingConstraint.constant = CGFloat(self.indentLeft)
		self.trailingConstraint.constant = CGFloat(self.indentRight)
	}
}
