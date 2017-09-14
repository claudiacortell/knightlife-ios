//
//  Utils.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class TimeUtils
{
	static func currentDateAsString() -> String
	{
		let date = Date()
		let calendar = Calendar.current
		
		let components = calendar.dateComponents([.month, .year, .day], from: date)
		
		let month = components.month
		let year = components.year
		let day = components.day
		
		var monthString = String(describing: month!)
		monthString = ((monthString.characters.count == 1 ? "0" : "") + monthString)
		
		var outDate = String(describing: year!) + "-"
		outDate += monthString
		outDate += "-" + String(describing: day!)
  
		return outDate
	}
	
	static func getDayOfWeekFromString(_ today: String) -> Int
	{
		let formatter  = DateFormatter()
		
		formatter.dateFormat = "yyyy-MM-dd"
		
		let todayDate = formatter.date(from: today)!
		let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
		let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
		var weekDay = myComponents.weekday
		
		if (weekDay == 1)
		{
			weekDay = 6
		}
		else
		{
			weekDay = weekDay! - 2;
		}
		
		return weekDay!
	}
	
	static func timeToNSDate(_ time: String) -> Date
	{
		var currentDate = TimeUtils.currentDateAsString()
		
		let formatter  = DateFormatter()
		formatter.timeZone = TimeZone.autoupdatingCurrent
		formatter.dateFormat = "yyyy-MM-dd-HH-mm"
		currentDate += time;
		
		let outDate = formatter.date(from: currentDate)!
		return outDate;
	}
	
	static func NSDateToString(_ time: Date) -> String
	{
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.autoupdatingCurrent
		let components = (calendar as NSCalendar).components([.month, .year, .day, .hour, .minute], from: time)
		
		let month = components.month
		let year = components.year
		let day = components.day
		let hour = components.hour
		
		let minute = components.minute
		
		var monthString = String(describing: month)
		if(monthString.characters.count == 1){
			monthString = "0" + monthString
		}
		var hourString = String(describing: hour)
		if(hourString.characters.count == 1){
			hourString = "0" + hourString
		}
		var minuteString = String(describing: minute)
		if(minuteString.characters.count == 1){
			minuteString = "0" + minuteString
		}
		
		var outDate = String(describing: year) + "-"
		outDate += monthString
		outDate += "-" + String(describing: day)
		outDate += "-" + hourString
		outDate += "-" + minuteString
		
		return outDate
	}
	
	static func NSDateToStringWidget(_ time: Date) -> String
	{
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.autoupdatingCurrent
		let components = (calendar as NSCalendar).components([.month, .year, .day, .hour, .minute], from: time)
		
		let hour = components.hour!
		let minute = components.minute!
		
		var hourString = String(describing: hour)
		if(hourString.characters.count == 1){
			hourString = "0" + hourString
		}
		var minuteString = String(describing: minute)
		if(minuteString.characters.count == 1){
			minuteString = "0" + minuteString
		}
		
		var outDate = "-"
		outDate += hourString
		outDate += "-" + minuteString
		
		return outDate
	}
}
