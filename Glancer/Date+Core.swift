//
//  Date+Core.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/24/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

extension Date {
	
	static func fromWebTime(string: String) -> Date? {
		return Date.webTimeFormatter.date(from: string)
	}
	
	static func fromWebDate(string: String) -> Date? {
		return Date.webDateFormatter.date(from: string)
	}
	
	static var today: Date {
		return Date()
	}
	
	static let normalizedFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar.normalizedCalendar
		formatter.locale = Calendar.locale_us
		formatter.timeZone = Calendar.timezone
		return formatter
	}()
	
	static let webDateFormatter: DateFormatter = {
		let formatter = Date.normalizedFormatter
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()
	
	static let webTimeFormatter: DateFormatter = {
		let formatter = Date.normalizedFormatter
		formatter.dateFormat = "HH-mm"
		return formatter
	}()
	
	var webSafeDate: String {
		return Date.webDateFormatter.string(from: self)
	}
	
	var webSafeTime: String {
		return Date.webTimeFormatter.string(from: self)
	}
	
	var dayOfWeek: Int {
		var raw = Calendar.normalizedCalendar.component(.weekday, from: self)
		if (raw == 1) { raw = 6 } else { raw -= 2; }
		return raw
	}
	
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
		return Calendar.normalizedCalendar.dateComponents([.day], from: self, to: date).day!
	}
	
	func dayInRelation(offset: Int) -> Date {
		return Calendar.normalizedCalendar.date(byAdding: .day, value: offset, to: self)!
	}
	
}
