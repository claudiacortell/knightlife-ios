//
//  DayID.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

enum DayID: String // DO NOT EVER CHANGE ANYTHING IN THIS CLASS I SWEAR TO GOD IT'LL KILL YOU AND YOUR FAMILY AND YOU DON'T WANT THAT retrospectively this statement is factually incorrect
{
	case
	monday = "M",
	tuesday = "T",
	wednesday = "W",
	thursday = "Th",
	friday = "F",
	saturday = "Sa",
	sunday = "Su"
	
	var displayName: String
	{
		switch self
		{
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
	
	var nextDay: DayID
	{
		var id = self.id
		id += 1
		return DayID.values()[id % 7]
	}
	
	var id: Int
	{
		return DayID.values().index(of: self)!
	}
	
	static func weekdays() -> [DayID] { return [.monday, .tuesday, .wednesday, .thursday, .friday] }
	static func weekends() -> [DayID] { return [.saturday, .sunday] }
	static func values() -> [DayID] { return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] }
	
	static func fromRaw(raw: String) -> DayID?
	{
		for day in DayID.values()
		{
			if day.rawValue == raw
			{
				return day
			}
		}
		return nil
	}
	
	static func fromId(_ id: Int) -> DayID
	{
		return DayID.values()[id]
		
//		if let day = DayID.values()[id]
//		{
//			return day
//		}
//		return nil
	}
}
