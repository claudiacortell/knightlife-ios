//
//  DayOfWeek.swift
//  Pods
//
//  Created by Dylan Hanson on 4/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

public enum DayOfWeek: Int {
	
	case monday
	case tuesday
	case wednesday
	case thursday
	case friday
	case saturday
	case sunday
	
	init?(shortName: String) {
		for day in DayOfWeek.values {
			if day.shortName == shortName {
				self = day
				return
			}
		}
		return nil
	}
	
	var shortName: String {
		switch self {
		case .monday:
			return "m"
		case .tuesday:
			return "t"
		case .wednesday:
			return "w"
		case .thursday:
			return "th"
		case .friday:
			return "f"
		case .saturday:
			return "sa"
		case .sunday:
			return "su"
		}
	}
	
	var displayName: String {
		switch self {
		case .monday:
			return "Monday"
		case .tuesday:
			return "Tuesday"
		case .wednesday:
			return "Wednesday"
		case .thursday:
			return "Thursday"
		case .friday:
			return "Friday"
		case .saturday:
			return "Saturday"
		case .sunday:
			return "Sunday"
		}
	}
	
	var nextDay: DayOfWeek {
		var id = self.rawValue
		id += 1
		return DayOfWeek(rawValue: (id % 7))!
	}
	
	static var weekdays: [DayOfWeek] { return [.monday, .tuesday, .wednesday, .thursday, .friday] }
	static var weekends: [DayOfWeek] { return [.saturday, .sunday] }
	static var values: [DayOfWeek] { return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] }
	
	static func fromShortName(shortName: String) -> DayOfWeek? {
		for day in DayOfWeek.values {
			if day.shortName == shortName {
				return day
			}
		}
		return nil
	}
	
}
