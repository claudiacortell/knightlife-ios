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
	
	static func timeToDateInMinutes(to: Date) -> Int
	{
		let cur = Date()
		var components = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: cur, to: to)
		
		let hours = components.hour!
		let minutes = components.minute!
		
		return (hours * 60) + minutes // Convert the hours to minutes then add the other minutes.
	}
}

class Utils
{
	static func getHexFromCGColor(_ color: CGColor) -> String
	{
		let components = color.components
		let r: CGFloat = components![0]
		let g: CGFloat = components![1]
		let b: CGFloat = components![2]
		
		let hexString: NSString = NSString(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
		
		return hexString as String
	}
	
	static func getRGBFromHex(_ hex: String) -> [CGFloat]
	{
		let cString:String = hex.trimmingCharacters(in: .whitespaces).uppercased()
		
		let rString = cString.substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
		let gString = cString.substring(from: hex.characters.index(hex.startIndex, offsetBy: 2)).substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
		let bString = cString.substring(from: hex.characters.index(hex.startIndex, offsetBy: 4)).substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
		
		var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
		
		Scanner(string: rString).scanHexInt32(&r)
		Scanner(string: gString).scanHexInt32(&g)
		Scanner(string: bString).scanHexInt32(&b)
		
		let redFloat: CGFloat = CGFloat(r)
		let greenFloat: CGFloat = CGFloat(g)
		let blueFloat:CGFloat = CGFloat(b)
		
		var values: [CGFloat] = [CGFloat]()
		
		values.append(redFloat)
		values.append(greenFloat)
		values.append(blueFloat)
		
		return values
	}
	
	static func getUIColorFromHex (_ hex: String) -> UIColor
	{
		let cString = Utils.substring(hex, StartIndex: 0, EndIndex: 6)
		
		var rgbValue:UInt32 = 0
		Scanner(string: cString).scanHexInt32(&rgbValue)
		
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	static func substring(_ origin: String, StartIndex : Int, EndIndex : Int) -> String
	{
		var counter = 0
		var subString = ""
		for char in origin.characters
		{
			if (StartIndex <= counter && counter < EndIndex)
			{
				subString += String(char)
			}
			counter += 1
		}
		
		return subString
	}
}
