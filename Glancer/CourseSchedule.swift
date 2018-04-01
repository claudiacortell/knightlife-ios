//
//  CourseSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

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
	
    private var meetingDays: [DayID]? // Only used for specific day meetings

	init(block: BlockID, frequency: CourseFrequency)
	{
		self.block = block
		self.frequency = frequency
	}
	
	func meetingDaysContains(_ day: DayID) -> Bool
	{
		if let days = self.meetingDays
		{
			return days.contains(day)
		}
		return false
	}
	
	func addMeetingDay(_ day: DayID)
	{
		if !self.meetingDaysContains(day)
		{
			if self.meetingDays == nil { self.meetingDays = [] }
			self.meetingDays!.append(day)
		}
	}
	
	func removeMeetingDay(_ day: DayID)
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
