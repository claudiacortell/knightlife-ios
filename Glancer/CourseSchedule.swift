//
//  CourseSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

enum CourseFrequency {
	
    case everyDay
	case specificDays([DayOfWeek])
	
}

class CourseSchedule {
	
    var block: BlockID //Null = all day
	var frequency: CourseFrequency
	
	init(block: BlockID, frequency: CourseFrequency) {
		self.block = block
		self.frequency = frequency
	}
	
	func meetingDaysContains(_ day: DayOfWeek) -> Bool {
		switch self.frequency {
		case .everyDay:
			return false
		case .specificDays(let days):
			return days.contains(day)
		}
	}
	
	func addMeetingDay(_ day: DayOfWeek) -> Bool {
		switch self.frequency {
		case .specificDays(var days):
			days.append(day)
			return true
		default:
			break
		}
		return false
	}
	
	func removeMeetingDay(_ day: DayOfWeek) -> Bool {
		switch self.frequency {
		case .specificDays(var days):
			for i in 0..<days.count {
				if days[i] == day {
					days.remove(at: i)
					return true
				}
			}
		default:
			break
		}
		return false
	}
	
}
