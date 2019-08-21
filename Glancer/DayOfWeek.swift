//
//  DayOfWeek.swift
//  Pods
//
//  Created by Dylan Hanson on 4/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

/*creates a DayOfWeek object class.
 the raw values of each case are ints, so 0 - 6 for each day
 
 instance variables:
    - shortName : String
    - displayName : String
    - nextDay : DayOfWeeek
        it adds 1 to the raw value to get the next case (day)
 
 functions
    - weekdays() -> [DayOfWeek]
        returns an array of DayOfWeek objects, one with a case monday, one with case tuesday, etc.
    - weekends() -> [DayOfWeek]
          returns an array of DayOfWeek objects (just cases saturday and sunday)
    - values() -> [DayOfWeek]
          returns an array of DayOfWeek objects (one case for each day)
    - fromShortName(shortName: String) -> DayOfWeek?
            takes in a string (its suppposed to be the shortName of day
            checks each day in the array created by values() using a for in loop
            if it matches, return day
            if it never ends up matching, return nil (hence the DayOfWeek? return type)
 */

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
	
	static func weekdays() -> [DayOfWeek] { return [.monday, .tuesday, .wednesday, .thursday, .friday]}
	static func weekends() -> [DayOfWeek] { return [.saturday, .sunday] }
	static func values() -> [DayOfWeek] { return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] }
	
	static func fromShortName(shortName: String) -> DayOfWeek? {
        //for in loops = for each loops
		for day in DayOfWeek.values() {
			if day.shortName == shortName {
				return day
			}
		}
		return nil
	}
	
}
