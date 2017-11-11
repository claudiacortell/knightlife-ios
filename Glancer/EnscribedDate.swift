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
	
	var valid: Bool
	{
		get
		{
			return self.year != -1 && self.month != -1 && self.day != -1
		}
	}
	
	init(year: Int, month: Int, day: Int)
	{
		self.year = year
		self.month = month
		self.day = day
	}
	
	init(raw: String = "")
	{
		let result = TimeUtils.unwrapRawDate(raw: raw)
		
		self.year = result.year
		self.month = result.month
		self.day = result.day
	}
}

extension EnscribedDate: Hashable
{
	static func <(lhs: EnscribedDate, rhs: EnscribedDate) -> Bool
	{
		
	}
	
	static func <=(lhs: EnscribedDate, rhs: EnscribedDate) -> Bool
	{
		
	}
	
	static func >(lhs: EnscribedDate, rhs: EnscribedDate) -> Bool
	{
		
	}
	
	static func >=(lhs: EnscribedDate, rhs: EnscribedDate) -> Bool
	{
		
	}
	
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
	
	func toDate() -> Date?
	{
		return TimeUtils.dateFromEnscribedDate(self)
	}
}
