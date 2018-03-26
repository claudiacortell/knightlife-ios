//
//  EnscribedDate.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct EnscribedDate
{
	let year: Int
	let month: Int
	let day: Int
	
	init?(_ date: Date)
	{
		let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
		if let year = components.year, let month = components.month, let day = components.day
		{
			self.init(year: year, month: month, day: day)
		} else
		{
			return nil
		}
	}
	
	init?(year: Int, month: Int, day: Int)
	{
		self.year = year
		self.month = month
		self.day = day
		
		if !TimeUtils.validEnscribedDate(self)
		{
			return nil
		}
	}
	
	init?(raw: String = "")
	{
		let result = TimeUtils.unwrapRawDate(raw: raw)
		self.init(year: result.year, month: result.month, day: result.day)
	}
}

extension EnscribedDate: Hashable
{
	static func ==(lhs: EnscribedDate, rhs: EnscribedDate) -> Bool
	{
		return
			lhs.year == rhs.year &&
				lhs.month == rhs.month &&
				lhs.day == rhs.day
	}
	
	var hashValue: Int
	{
		return self.day ^ self.month ^ self.year
	}
	
	var date: Date
	{
		return TimeUtils.dateFromEnscribedDate(self)
	}
	
	var dayOfWeek: DayID
	{
		return TimeUtils.getDayOfWeek(self)
	}
	
	var string: String
	{
		let month = self.month < 10 ? "0\(self.month)" : String(self.month)
		let day = self.day < 10 ? "0\(self.day)" : String(self.day)
		
		return "\(self.year)-\(month)-\(day)"
	}
	
	var prettyString: String
	{
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM"
		return "\(dayOfWeek.displayName), \(formatter.string(from: self.date)) \(self.day)"
	}
}
