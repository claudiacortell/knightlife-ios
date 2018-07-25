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
	
	var shortName: String {
		switch self {
		case .monday:
			return "M"
		case .tuesday:
			return "T"
		case .wednesday:
			return "W"
		case .thursday:
			return "Th"
		case .friday:
			return "F"
		case .saturday:
			return "Sa"
		case .sunday:
			return "Su"
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
	
	static func weekdays() -> [DayOfWeek] { return [.monday, .tuesday, .wednesday, .thursday, .friday] }
	static func weekends() -> [DayOfWeek] { return [.saturday, .sunday] }
	static func values() -> [DayOfWeek] { return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] }
	
	static func fromShortName(shortName: String) -> DayOfWeek? {
		for day in DayOfWeek.values() {
			if day.shortName == shortName {
				return day
			}
		}
		return nil
	}
	
}
