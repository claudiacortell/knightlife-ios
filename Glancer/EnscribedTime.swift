//
//  EnscribedTime.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct EnscribedTime
{
	let hour: Int
	let minute: Int
	
	var valid: Bool
	{
		get
		{
			return self.hour != -1 && self.minute != -1
		}
	}
	
	init(hour: Int, minute: Int)
	{
		self.hour = hour
		self.minute = minute
	}
	
	init(raw: String = "")
	{
		let result = TimeUtils.unwrapRawTime(raw: raw)
		
		self.hour = result.hour
		self.minute = result.minute
	}
}

extension EnscribedTime: Hashable
{
	static func ==(lhs: EnscribedTime, rhs: EnscribedTime) -> Bool
	{
		return
			lhs.hour == rhs.hour
			&& lhs.minute == rhs.minute
	}
	
	var hashValue: Int
	{
		return self.hour ^ self.minute
	}
	
	func toDate(enscribedDate: EnscribedDate = TimeUtils.todayEnscribed) -> Date?
	{
		return TimeUtils.dateFromEnscribed(enscribedDate: enscribedDate, enscribedTime: self)
	}
	
	func toString() -> String
	{
		let hour = self.hour > 12 ? self.hour % 12 + 1 : self.hour
		return "\(hour):\(minute)"
	}
}
