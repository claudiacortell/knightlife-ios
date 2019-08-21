//
//  Date+Core.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/24/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

extension Date {
	
	static func mergeDateAndTime(date: Date, time: Date) -> Date? {
		let mergedDateComponents = DateComponents(calendar: Calendar.normalizedCalendar, timeZone: Calendar.timezone, era: nil, year: date.year, month: date.month, day: date.day, hour: time.hour, minute: time.minute, second: time.second, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
		return Calendar.normalizedCalendar.date(from: mergedDateComponents)
	}
	
	static func fromWebTime(string: String) -> Date? {
		return Date.webTimeFormatter.date(from: string)
	}
	
	static func fromWebDate(string: String) -> Date? {
		return Date.webDateFormatter.date(from: string)
	}
	
	static var today: Date {
		return Date()
	}
	
	static var normalizedFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.calendar = Calendar.normalizedCalendar
		formatter.locale = Calendar.locale_us
		formatter.timeZone = Calendar.timezone
		return formatter
	}
	
	static var webDateFormatter: DateFormatter {
		let formatter = Date.normalizedFormatter
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}
	
	static var webTimeFormatter: DateFormatter {
		let formatter = Date.normalizedFormatter
		formatter.dateFormat = "HH-mm"
		return formatter
	}
	
	var webSafeDate: String {
		return Date.webDateFormatter.string(from: self)
	}
	
	var webSafeTime: String {
		return Date.webTimeFormatter.string(from: self)
	}
	
    
    //sets up dayOfWeek as 0-6 values, 0 = mon, 1 = tues, etc
	var dayOfWeek: Int {
		var raw = Calendar.normalizedCalendar.component(.weekday, from: self)
        print(raw)
		if (raw == 1) {
            raw = 6
        } else {
            raw -= 2
        }
		return raw
	}
	
    //returns the DayOfWeek object that corresponds with the rawValue created from dayOfWeek function above
	var weekday: DayOfWeek {
		return DayOfWeek(rawValue: self.dayOfWeek)!
	}
	
	var second: Int {
		return Calendar.normalizedCalendar.component(.second, from: self)
	}
	
	var minute: Int {
		return Calendar.normalizedCalendar.component(.minute, from: self)
	}
	
	var hour: Int {
		return Calendar.normalizedCalendar.component(.hour, from: self)
	}
	
	var day: Int {
		return Calendar.normalizedCalendar.component(.day, from: self)
	}
	
	var month: Int {
		return Calendar.normalizedCalendar.component(.month, from: self)
	}
	
	var year: Int {
		return Calendar.normalizedCalendar.component(.year, from: self)
	}
	
	func dayDifference(date: Date) -> Int {
		return Calendar.normalizedCalendar.dateComponents([.day], from: Calendar.normalizedCalendar.startOfDay(for: self), to: Calendar.normalizedCalendar.startOfDay(for: date)).day!
	}
	
	func minuteDifference(date: Date) -> Int {
		return Calendar.normalizedCalendar.dateComponents([.minute], from: self, to: date).minute!
	}
	
	func dayInRelation(offset: Int) -> Date {
		return Calendar.normalizedCalendar.date(byAdding: .day, value: offset, to: self)!
	}
	
    //sets up prettyTime, a string variable that has the time. Used throughout the app
	var prettyTime: String {
		let formatter = Date.normalizedFormatter
		formatter.dateFormat = "h:mma"
		formatter.amSymbol = "am"
		formatter.pmSymbol = "pm"
		return formatter.string(from: self)
	}
	
     //sets up prettyDate, a string variable that has the date. Used throughout the app (
	var prettyDate: String {
		let formatter = Date.normalizedFormatter
		formatter.dateFormat = "MMMM d"
		return "\(self.weekday.displayName), \(formatter.string(from: self))"
	}
	
}
