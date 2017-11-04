//
//  TimeDuration.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct TimeDuration
{
	let startTime: EnscribedTime
	let endTime: EnscribedTime
	
	init(startTime: EnscribedTime, endTime: EnscribedTime)
	{
		self.startTime = startTime
		self.endTime = endTime
	}
}


extension TimeDuration: Hashable
{
	static func ==(lhs: TimeDuration, rhs: TimeDuration) -> Bool
	{
		return lhs.startTime == rhs.startTime && lhs.endTime == rhs.endTime
	}
	
	var hashValue: Int
	{
		return startTime.hashValue ^ endTime.hashValue
	}
	
	func duration() -> (hours: Int, minutes: Int)
	{
		return (hours: abs(self.endTime.hour - self.startTime.hour), minutes: abs(self.endTime.minute - self.startTime.minute))
	}
}
