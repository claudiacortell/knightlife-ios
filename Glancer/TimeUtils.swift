//
//  TimeUtils.swift
//  Pods
//
//  Created by Dylan Hanson on 4/13/18.
//  Copyright © 2018 Charcoal Development. All rights reserved.
//

import Foundation

public class TimeUtils {
	
	public static let calender: Calendar = {
		var cal = Calendar(identifier: Calendar.Identifier.gregorian)
		return cal
	}()
	
	public static let calenderTimeZoned: Calendar = {
		var cal = Calendar(identifier: Calendar.Identifier.gregorian)
		cal.timeZone = TimeZone(abbreviation: "EST")!
		return cal
	}()
	
	public static var todayEnscribed: EnscribedDate {
		get {
			let now = Date()
			let calendar = TimeUtils.calender
			
			let year = calendar.component(.year, from: now)
			let month = calendar.component(.month, from: now)
			let day = calendar.component(.day, from: now)
			
			return EnscribedDate(year: year, month: month, day: day)!
		}
	}
	
	public static func dayOfWeek(_ date: Date = Date()) -> Int {
		var raw = TimeUtils.calender.component(.weekday, from: date)
		if (raw == 1) { raw = 6 } else { raw -= 2; }
		return raw
	}
	
	public static func isToday(_ date: EnscribedDate) -> Bool {
		return TimeUtils.dayDifference(TimeUtils.todayEnscribed, date) == 0
	}
	
	public static func isTomorrow(_ date: EnscribedDate) -> Bool {
		return TimeUtils.dayDifference(TimeUtils.todayEnscribed, date) == 1
	}
	
	public static func wasYesterday(_ date: EnscribedDate) -> Bool {
		return TimeUtils.dayDifference(TimeUtils.todayEnscribed, date) == -1
	}
	
	public static func daysUntil(_ date: EnscribedDate) -> Int {
		return TimeUtils.dayDifference(TimeUtils.todayEnscribed, date)
	}
	
	public static func dayDifference(_ date1: EnscribedDate, _ date2: EnscribedDate) -> Int {
		return TimeUtils.dayDifference(date1.date, date2.date)
	}
	
	public static func dayDifference(_ date1: Date, _ date2: Date) -> Int {
		return TimeUtils.calender.dateComponents([.day], from: date1, to: date2).day!
	}
	
	public static func isThisWeek(_ date: EnscribedDate) -> Bool {
		return TimeUtils.isThisWeek(date.date)
	}
	
	public static func isThisWeek(_ date: Date) -> Bool {
		if let startOfThisWeek = TimeUtils.getDayInRelation(Date(), offset: -TimeUtils.dayOfWeek()) {
			let diff = TimeUtils.dayDifference(startOfThisWeek, date)
			return diff >= 0 && diff < 6
		}
		return false
	}
	
	public static func dateFromEnscribed(enscribedDate: EnscribedDate = TimeUtils.todayEnscribed, enscribedTime: EnscribedTime) -> Date? {
		var dateComponents = DateComponents()
		
		dateComponents.year = enscribedDate.year
		dateComponents.month = enscribedDate.month
		dateComponents.day = enscribedDate.day
		
		dateComponents.hour = enscribedTime.hour
		dateComponents.minute = enscribedTime.minute
		
		return TimeUtils.calender.date(from: dateComponents)
	}
	
	public static func unwrapRawDate(raw: String) -> (year: Int, month: Int, day: Int) {
		var success = true
		
		let yearString = raw.substring(start: 0, distance: 4)
		let monthString = raw.substring(start: 5, distance: 2)
		let dayString = raw.substring(start: 8, distance: 2)
		
		if dayString.count != 2 || monthString.count != 2 || yearString.count != 4
		{
			success = false
		}
		
		let day = Int(dayString)
		let month = Int(monthString)
		let year = Int(yearString)
		
		if day == nil || month == nil || year == nil {
			success = false
		}
		
		if !success {
			return (year: -1, month: -1, day: -1)
		}
		
		return (year: year!, month: month!, day: day!)
	}
	
	public static func unwrapRawTime(raw: String) -> (hour: Int, minute: Int) {
		var success = true
		
		let hourString = raw.substring(start: 0, distance: 2)
		let minuteString = raw.substring(start: 3, distance: 2)
		
		if (hourString.count != 1 && hourString.count != 2) || (minuteString.count != 2 && minuteString.count != 1) {
			success = false
		}
		
		let hour = Int(hourString)
		let minute = Int(minuteString)
		
		if hour == nil || minute == nil {
			success = false
		}
		
		if !success {
			return (hour: -1, minute: -1)
		}
		return (hour: hour!, minute: minute!)
	}
	
	public static func validEnscribedDate(_ date: EnscribedDate) -> Bool {
		var dateComponents = DateComponents()
		
		dateComponents.year = date.year
		dateComponents.month = date.month
		dateComponents.day = date.day
		
		return TimeUtils.calender.date(from: dateComponents) != nil
	}
	
	public static func dateFromEnscribedDate(_ enscribedDate: EnscribedDate) -> Date {
		var dateComponents = DateComponents()
		
		dateComponents.year = enscribedDate.year
		dateComponents.month = enscribedDate.month
		dateComponents.day = enscribedDate.day
		
		return TimeUtils.calender.date(from: dateComponents)!
	}
	
	public static func getDayOfWeek(_ enscribedDate: EnscribedDate = TimeUtils.todayEnscribed) -> Day {
		let date = TimeUtils.dateFromEnscribedDate(enscribedDate)
		return Day.fromId(TimeUtils.dayOfWeek(date))
	}
	
	public static func timeToDateInMinutes(to: Date) -> (years: Int, days: Int, hours: Int, minutes: Int, seconds: Int) {
		let cur = Date()
		var components = TimeUtils.calender.dateComponents([.year, .day, .hour, .minute, .second], from: cur, to: to)
		
		let years = components.year!
		let days = components.day!
		let hours = components.hour!
		let minutes = components.minute!
		let seconds = components.second!
		
		return (years: years, days: days, hours: hours, minutes: minutes, seconds: seconds) //Add one to account for seconds difference that's ignored.
	}
	
	public static func getDayInRelation(_ to: EnscribedDate, offset: Int) -> EnscribedDate? {
		if let date = TimeUtils.getDayInRelation(to.date, offset: offset) {
			return EnscribedDate(date)
		}
		return nil
	}
	
	public static func getDayInRelation(_ date: Date, offset: Int) -> Date? {
		if let newDate = TimeUtils.calender.date(byAdding: .day, value: offset, to: date) {
			return newDate
		}
		return nil
	}
	
	public static func timeToString(years: Int, days: Int, hours: Int, min: Int, sec: Int, displayAmount: Int = 2) -> String {
		var vYears = abs(years)
		var vDays = abs(days)
		var vHours = abs(hours)
		var vMin = abs(min)
		var vSec = abs(sec)
		
		var elements: [String] = []
		
		while vSec >= 60 {
			vSec -= 60
			vMin += 1
		}
		
		while vMin >= 60 {
			vMin -= 60
			vHours += 1
		}
		
		while vHours >= 24 {
			vHours -= 24
			vDays += 1
		}
		
		while vDays >= 365 {
			vDays -= 365
			vYears += 1
		}
		
		let yS = "\(vYears)y"
		let dS = "\(vDays)d"
		let hS = "\(vHours)h"
		let mS = "\(vMin)m"
		let sS = "\(vSec)s"
		
		if vYears != 0 { elements.append(yS) }
		if vDays != 0 { elements.append(dS) }
		if vHours != 0 { elements.append(hS) }
		if vMin != 0 { elements.append(mS) }
		if vSec != 0 { elements.append(sS) }
		
		var assembled = ""
		for i in 0..<displayAmount {
			if i < elements.count {
				assembled += (elements[i] + " ")
			}
		}
		
		return "\(assembled.dropLast())"
	}
}
