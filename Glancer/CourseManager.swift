//
//  CourseManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/25/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

class CourseManager: Manager {
	
	static let instance = CourseManager()
	
	private(set) var meetings: [Course] = [] // All added meetings including one time ones.
	let meetingsUpdatedWatcher = ResourceWatcher<Course>()
	
	init() {
		super.init("Meetings")
		
		self.registerStorage(MeetingPrefModule(self))		
	}
	
	func loadedCourse(course: Course) {
		self.meetings.append(course)
	}
	
	func courseChanged(course: Course) {
		self.saveStorage()
		self.meetingsUpdatedWatcher.handle(nil, course)
	}
	
	func removeCourse(_ meeting: Course) {
		while self.meetings.contains(meeting) {
			for i in 0..<self.meetings.count {
				if self.meetings[i] == meeting {
					self.meetings.remove(at: i)
					
					self.courseChanged(course: meeting)
					break
				}
			}
		}
	}
	
	func addCourse(_ meeting: Course) {
		self.meetings.append(meeting)
		self.courseChanged(course: meeting)
	}
	
	func getCourses(schedule: DateSchedule, block: BlockID) -> BlockCourseList {
		return self.getCourses(date: schedule.date, schedule: schedule).fromBlock(block)
	}
	
	func getCourses(date: Date, schedule: DateSchedule) -> DayCourseList {
		var list: [Course] = []
		
		for activity in self.meetings {
			if self.doesMeetOnDate(activity, date: date, schedule: schedule) {
				list.append(activity)
			}
		}
		
		return DayCourseList(date: date, meetings: list)
	}
	
	private func doesMeetOnDate(_ meeting: Course, date: Date, schedule: DateSchedule) -> Bool {
		let meetingSchedule = meeting.courseSchedule
		switch meetingSchedule.frequency {
		case .everyDay:
			if schedule.hasBlock(meetingSchedule.block) {
				return true
			}
			break
		case .specificDays:
			if let daySub = schedule.day { // Is actually standing in for a different day.
				if meetingSchedule.meetingDaysContains(daySub) {
					if schedule.hasBlock(meetingSchedule.block) {
						return true
					}
				}
			} else {
				if meetingSchedule.meetingDaysContains(date.weekday) {
					if schedule.hasBlock(meetingSchedule.block) {
						return true
					}
				}
			}
			break
		}
		return false
	}
}
