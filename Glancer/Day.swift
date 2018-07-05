//
//  Day.swift
//  Pods
//
//  Created by Dylan Hanson on 4/13/18.
//  Copyright © 2018 Charcoal Development. All rights reserved.
//

import Foundation

public enum Day: String {
	
	case
	monday = "M",
	tuesday = "T",
	wednesday = "W",
	thursday = "Th",
	friday = "F",
	saturday = "Sa",
	sunday = "Su"
	
	public var displayName: String {
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
	
	public var nextDay: Day {
		var id = self.id
		id += 1
		return Day.values()[id % 7]
	}
	
	public var id: Int {
		return Day.values().index(of: self)!
	}
	
	public static func weekdays() -> [Day] { return [.monday, .tuesday, .wednesday, .thursday, .friday] }
	public static func weekends() -> [Day] { return [.saturday, .sunday] }
	public static func values() -> [Day] { return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] }
	
	public static func fromRaw(raw: String) -> Day? {
		for day in Day.values() {
			if day.rawValue == raw {
				return day
			}
		}
		return nil
	}
	
	public static func fromId(_ id: Int) -> Day {
		return Day.values()[id]
	}
	
}
