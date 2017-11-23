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
	static var todayEnscribed: EnscribedDate
	{
		get
		{
			let now = Date()
			let calendar = Calendar.current
			
			let year = calendar.component(.year, from: now)
			let month = calendar.component(.month, from: now)
			let day = calendar.component(.day, from: now)
			
			return EnscribedDate(year: year, month: month, day: day)
		}
	}
	
	static func dateFromEnscribed(enscribedDate: EnscribedDate = TimeUtils.todayEnscribed, enscribedTime: EnscribedTime) -> Date?
	{
		var dateComponents = DateComponents()
		dateComponents.year = enscribedDate.year
		dateComponents.month = enscribedDate.month
		dateComponents.day = enscribedDate.day
		
		dateComponents.hour = enscribedTime.hour
		dateComponents.minute = enscribedTime.minute
		
		dateComponents.timeZone = TimeZone(abbreviation: "EST")
		
		return Calendar.current.date(from: dateComponents)
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
	
	static func dateFromEnscribedDate(_ enscribedDate: EnscribedDate) -> Date?
	{
		var dateComponents = DateComponents()
		dateComponents.year = enscribedDate.year
		dateComponents.month = enscribedDate.month
		dateComponents.day = enscribedDate.day
		dateComponents.timeZone = TimeZone(abbreviation: "EST")
		
		return Calendar.current.date(from: dateComponents)
	}
	
	static func getDayOfWeek(_ enscribedDate: EnscribedDate = TimeUtils.todayEnscribed) -> DayID?
	{
		if let date = TimeUtils.dateFromEnscribedDate(enscribedDate)
		{
			var weekday = Calendar.current.component(.weekday, from: date)
			if (weekday == 1)
			{
				weekday = 6
			} else
			{
				weekday = weekday - 2;
			}
			
			return DayID.fromId(weekday)
		}
		return nil
	}
	
	static func timeToDateInMinutes(to: Date) -> (hours: Int, minutes: Int)
	{
		let cur = Date()
		var components = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: cur, to: to)
		
		let hours = components.hour!
		let minutes = components.minute!
		
		return (hours: hours, minutes: minutes + 1) //Add one to account for seconds difference that's ignored.
	}
}
