//
//  CourseSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

enum CourseFrequency
{
    case
    everyDay,
    specificDays
}

class CourseSchedule
{
    var block: BlockID //Null = all day
	var frequency: CourseFrequency
	
    private var meetingDays: [Day]? // Only used for specific day meetings

	init(block: BlockID, frequency: CourseFrequency)
	{
		self.block = block
		self.frequency = frequency
	}
	
	func meetingDaysContains(_ day: Day) -> Bool
	{
		if let days = self.meetingDays
		{
			return days.contains(day)
		}
		return false
	}
	
	func addMeetingDay(_ day: Day)
	{
		if !self.meetingDaysContains(day)
		{
			if self.meetingDays == nil { self.meetingDays = [] }
			self.meetingDays!.append(day)
		}
	}
	
	func removeMeetingDay(_ day: Day)
	{
		while self.meetingDaysContains(day)
		{
			for i in 0..<self.meetingDays!.count
			{
				if self.meetingDays![i] == day
				{
					self.meetingDays!.remove(at: i)
					break
				}
			}
		}
	}
}
