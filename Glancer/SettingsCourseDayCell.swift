//
//  SettingsDayCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/7/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class SettingsCourseDayCell: TableCell {
	
	init(course: Course, day: DayOfWeek, selection: @escaping (IndexPath, DayOfWeek, Bool) -> Void) {
		super.init("courseday", nib: "SettingsCourseDayCell")
		
		self.setHeight(34)
		
		self.setSelection() {
			template, path in
			
			selection(path, day, !course.schedule.meetingDaysContains(day))
		}
		
		self.setCallback() {
			template, cell in
			
			guard let dayCell = cell as? UISettingsCourseDayCell else {
				return
			}
			
			let selected = course.schedule.meetingDaysContains(day)
			
			dayCell.dayLabel.text = day.displayName
			dayCell.dayLabel.textColor = Scheme.blue.color
			
			dayCell.dayLabel.layer.opacity = selected ? 1.0 : 0.6
			
			dayCell.accessoryType = selected ? .checkmark : .none
			dayCell.tintColor = Scheme.blue.color
		}
	}
	
}

class UISettingsCourseDayCell: UITableViewCell {
	
	@IBOutlet weak var dayLabel: UILabel!
	
}
