//
//  CourseManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/25/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class CourseManager: Manager
{
	static let instance = CourseManager()
	
	private(set) var meetings: [Course] // All added meetings including one time ones.
	
	init()
	{
		self.meetings = []
		super.init(name: "Meetings Manager")
		
		self.registerModule(MeetingPrefModule(self, name: "courses"))
	}
	
	func getCourses() -> [Course]
	{
		return self.meetings
	}
	
	func addCourse(_ meeting: Course)
	{
		self.meetings.append(meeting)
	}
	
	//	TODO: Implement a callback system for courses changed.
	
	func getCourses(schedule: DateSchedule, block: BlockID) -> BlockCourseList
	{
		return self.getCourses(date: schedule.date, schedule: schedule).fromBlock(block)
	}
	
	func getCourses(date: EnscribedDate, schedule: DateSchedule) -> DayCourseList // You have to supply your own schedule. I don't wanna have to deal with calling it and dealing with the web call
	{
		var list: [Course] = []
		
		for activity in self.meetings
		{
			if self.doesMeetOnDate(activity, date: date, schedule: schedule)
			{
				list.append(activity)
			}
		}
		
		return DayCourseList(date, list)
	}
	
	private func doesMeetOnDate(_ meeting: Course, date: EnscribedDate, schedule: DateSchedule) -> Bool
	{
		if let meetingSchedule = meeting.courseSchedule
		{
			switch meetingSchedule.frequency
			{
			case .everyDay:
				if schedule.hasBlock(meetingSchedule.block)
				{
					return true
				}
				break
			case .specificDays:
				if let meetingDays = meetingSchedule.meetingDays
				{
					if meetingDays.contains(date.dayOfWeek)
					{
						if schedule.hasBlock(meetingSchedule.block)
						{
							return true
						}
					}
				}
				break
			}
		}
		return false
	}
}
