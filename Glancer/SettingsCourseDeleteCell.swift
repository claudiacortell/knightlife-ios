//
//  SettingsCourseDeleteCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class SettingsCourseDeleteCell: TableCell {
	
	init(clicked: @escaping () -> Void) {
		super.init("coursedelete", nib: "SettingsCourseDeleteCell")
		
		self.setHeight(44)
		
		self.setSelection() {
			_, _ in
			
			clicked()
		}
	}
	
}

class UISettingsCourseDeleteCell: UITableViewCell {
	
	
	
}
