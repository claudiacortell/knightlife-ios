//
//  TimeUtils.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class TimeUtils
{
	static let calender: Calendar =
	{
		var cal = Calendar(identifier: Calendar.Identifier.gregorian)
		return cal
	}()
	
	static let calenderTimeZoned: Calendar =
	{
		var cal = Calendar(identifier: Calendar.Identifier.gregorian)
		cal.timeZone = TimeZone(abbreviation: "EST")!
		return cal
	}()
	
	static var todayEnscribed: EnscribedDate
	{
		get
		{
			let now = Date()
			let calendar = TimeUtils.calender
			
			let year = calendar.component(.year, from: now)
			let month = calendar.component(.month, from: now)
			let day = calendar.component(.day, from: now)
			
			return EnscribedDate(year: year, month: month, day: day)!
		}
	}
	
	static func dayOfWeek(_ date: Date = Date()) -> Int
	{
		var raw = TimeUtils.calender.component(.weekday, from: date)
		if (raw == 1) { raw = 6 } else { raw -= 2; }
		return raw
	}
	
	static func isToday(_ date: EnscribedDate) -> Bool
	{
		return TimeUtils.dayDifference(TimeUtils.todayEnscribed, date) == 0
	}
	
	static func isTomorrow(_ date: EnscribedDate) -> Bool
	{
		return TimeUtils.dayDifference(TimeUtils.todayEnscribed, date) == 1
	}
	
	static func wasYesterday(_ date: EnscribedDate) -> Bool
	{
		return TimeUtils.dayDifference(TimeUtils.todayEnscribed, date) == -1
	}
	
	static func daysUntil(_ date: EnscribedDate) -> Int
	{
		return TimeUtils.dayDifference(TimeUtils.todayEnscribed, date)
	}
	
	static func dayDifference(_ date1: EnscribedDate, _ date2: EnscribedDate) -> Int
	{
		return TimeUtils.dayDifference(date1.date, date2.date)
	}
	
	static func dayDifference(_ date1: Date, _ date2: Date) -> Int
	{
		return TimeUtils.calender.dateComponents([.day], from: date1, to: date2).day!
	}
	
	static func isThisWeek(_ date: EnscribedDate) -> Bool
	{
		return TimeUtils.isThisWeek(date.date)
	}
	
	static func isThisWeek(_ date: Date) -> Bool
	{
		if let startOfThisWeek = TimeUtils.getDayInRelation(Date(), offset: -TimeUtils.dayOfWeek())
		{
			let diff = TimeUtils.dayDifference(startOfThisWeek, date)
			return diff >= 0 && diff < 6
		}
		return false
	}
	
	static func dateFromEnscribed(enscribedDate: EnscribedDate = TimeUtils.todayEnscribed, enscribedTime: EnscribedTime) -> Date?
	{
		var dateComponents = DateComponents()
		
		dateComponents.year = enscribedDate.year
		dateComponents.month = enscribedDate.month
		dateComponents.day = enscribedDate.day
		
		dateComponents.hour = enscribedTime.hour
		dateComponents.minute = enscribedTime.minute
		
		return TimeUtils.calender.date(from: dateComponents)
	}
	
	static func unwrapRawDate(raw: String) -> (year: Int, month: Int, day: Int)
	{
		var success = true

		let yearString = Utils.substring(raw, start: 0, distance: 4)
		let monthString = Utils.substring(raw, start: 5, distance: 2)
		let dayString = Utils.substring(raw, start: 8, distance: 2)
		
		if dayString.count != 2 || monthString.count != 2 || yearString.count != 4
		{
			success = false
		}
		
		let day = Int(dayString)
		let month = Int(monthString)
		let year = Int(yearString)
		
		if day == nil || month == nil || year == nil
		{
			success = false
		}
		
		if !success
		{
			return (year: -1, month: -1, day: -1)
		}
		
		return (year: year!, month: month!, day: day!)
	}
	
	static func unwrapRawTime(raw: String) -> (hour: Int, minute: Int)
	{
		var success = true
		
		let hourString = Utils.substring(raw, start: 0, distance: 2)
		let minuteString = Utils.substring(raw, start: 3, distance: 2)
		
		if (hourString.count != 1 && hourString.count != 2) || (minuteString.count != 2 && minuteString.count != 1)
		{
			success = false
		}
		
		let hour = Int(hourString)
		let minute = Int(minuteString)
		
		if hour == nil || minute == nil
		{
			success = false
		}
		
		if !success
		{
			return (hour: -1, minute: -1)
		}
		return (hour: hour!, minute: minute!)
	}
	
	static func validEnscribedDate(_ date: EnscribedDate) -> Bool
	{
		var dateComponents = DateComponents()
		
		dateComponents.year = date.year
		dateComponents.month = date.month
		dateComponents.day = date.day
		
		return TimeUtils.calender.date(from: dateComponents) != nil
	}
	
	static func dateFromEnscribedDate(_ enscribedDate: EnscribedDate) -> Date
	{
		var dateComponents = DateComponents()
		
		dateComponents.year = enscribedDate.year
		dateComponents.month = enscribedDate.month
		dateComponents.day = enscribedDate.day
		
		return TimeUtils.calender.date(from: dateComponents)!
	}
	
	static func getDayOfWeek(_ enscribedDate: EnscribedDate = TimeUtils.todayEnscribed) -> DayID
	{
		let date = TimeUtils.dateFromEnscribedDate(enscribedDate)
		print(TimeUtils.dayOfWeek(date))
		return DayID.fromId(TimeUtils.dayOfWeek(date))
	}
	
	static func timeToDateInMinutes(to: Date) -> (hours: Int, minutes: Int)
	{
		let cur = Date()
		var components = TimeUtils.calender.dateComponents([.hour, .minute], from: cur, to: to)
		
		let hours = components.hour!
		let minutes = components.minute!
		
		return (hours: hours, minutes: minutes + 1) //Add one to account for seconds difference that's ignored.
	}
	
	static func getDayInRelation(_ to: EnscribedDate, offset: Int) -> EnscribedDate?
	{
		if let date = TimeUtils.getDayInRelation(to.date, offset: offset)
		{
			return EnscribedDate(date)
		}
		return nil
	}
	
	static func getDayInRelation(_ date: Date, offset: Int) -> Date?
	{
		if let newDate = TimeUtils.calender.date(byAdding: .day, value: offset, to: date)
		{
			return newDate
		}
		return nil
	}
}
