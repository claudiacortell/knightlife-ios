//
//  CourseManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/25/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

class CourseManager: Manager
{
	static let instance = CourseManager()
	
	private(set) var meetings: [Course] // All added meetings including one time ones.
	
	init()
	{
		self.meetings = []
		super.init("Meetings Manager")
		
		self.registerStorage(MeetingPrefModule(self))
	}
	
	func getCourses() -> [Course]
	{
		return self.meetings
	}
	
	func removeCourse(_ meeting: Course)
	{
		while self.meetings.contains(meeting)
		{
			for i in 0..<self.meetings.count
			{
				if self.meetings[i] === meeting
				{
					self.meetings.remove(at: i)
					break
				}
			}
		}
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
		let meetingSchedule = meeting.courseSchedule
		switch meetingSchedule.frequency
		{
		case .everyDay:
			if schedule.hasBlock(meetingSchedule.block)
			{
				return true
			}
			break
		case .specificDays:
			if meetingSchedule.meetingDaysContains(date.dayOfWeek)
			{
				if schedule.hasBlock(meetingSchedule.block)
				{
					return true
				}
			}
			break
		}
		return false
	}
}
