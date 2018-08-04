//
//  SettingsCourseColorCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/4/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class SettingsCourseColorCell: TableCell {
	
	init(color: UIColor, clicked: @escaping () -> Void ) {
		super.init("coursecolor", nib: "SettingsCourseColorCell")
		
		self.setHeight(44)
		
		
		self.setCallback() {
			template, cell in
			
			guard let colorCell = cell as? UISettingsCourseColorCell else {
				return
			}
			
			colorCell.colorView.backgroundColor = color
		}
		
		self.setSelection() {
			template, cell in
			
			clicked()
		}
	}
	
}

class UISettingsCourseColorCell: UITableViewCell {
	
	@IBOutlet weak var colorView: UIView!
	
}
