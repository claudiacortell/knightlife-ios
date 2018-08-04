//
//  SettingsCourseTextCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/4/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class SettingsCourseTextCell: TableCell {
	
	init(left: String, right: String, clicked: @escaping () -> Void) {
		super.init("coursetext", nib: "SettingsCourseTextCell")
		
		self.setHeight(44)
		
		self.setDeselectOnSelection(true)
		
		self.setCallback() {
			template, cell in
			
			guard let textCell = cell as? UISettingsCourseTextCell else {
				return
			}
			
			textCell.leftLabel.text = left
			textCell.rightLabel.text = right
		}
		
		self.setSelection() {
			template, cell in
			
			clicked()
		}
	}
	
}

class UISettingsCourseTextCell: UITableViewCell {
	
	@IBOutlet weak var leftLabel: UILabel!
	@IBOutlet weak var rightLabel: UILabel!
	
}
