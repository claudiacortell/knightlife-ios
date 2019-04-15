//
//  CourseSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

enum CourseSchedule {
	
	case everyDay(Block.ID?)
	case specificDays(Block.ID?, [DayOfWeek])
	
}

extension CourseSchedule {
	
	func meetingDaysContains(_ day: DayOfWeek) -> Bool {
		switch self {
		case .specificDays(_, let days):
			return days.contains(day)
		default: return false
		}
	}
	
}

extension CourseSchedule {
	
	var intValue: Int {
		switch self {
		case .everyDay(_): return 0
		case .specificDays(_, _): return 1
		}
	}
	
}
