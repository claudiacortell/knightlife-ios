//
//  CourseManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/25/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Signals
import AddictiveLib
import SwiftyUserDefaults

private(set) var CourseM = CourseManager()

extension DefaultsKeys {
	
	fileprivate static let courseMigratedToRealm = DefaultsKey<Bool>("migrated.course")
	
}

class CourseManager {
	
	let onMeetingUpdate = Signal<Course>()
	
	fileprivate init() {
		
	}
	
	func loadLegacyData() {
		if !Defaults[.courseMigratedToRealm] {
			let oldStorage = MeetingPrefModule(self)
			StorageHub.instance.loadPrefs(oldStorage)
			
			Defaults[.courseMigratedToRealm] = true
		}
	}
	
	func loadLegacyCourse(course: Course) {
		try! Realms.write {
			Realms.add(course, update: true)
		}
		
		print("Loaded legacy course \( course.name )")
	}
	
	var courses: [Course] {
		return Array(Realms.objects(Course.self))
	}
	
	func createCourse(name: String) -> Course {
		let course = Course()
		
		course.name = name
		
		try! Realms.write {
			Realms.add(course)
		}
		
		return course
	}
	
	func deleteCourse(course: Course) {
		try! Realms.write {
			Realms.delete(course)
		}
	}
	
	func getCourses(block: Block) -> [Course] {
		return self.getCourses(schedule: block.timetable.schedule).filter({ $0.scheduleBlock == block.id })
	}
	
	func getCourses(schedule: Schedule) -> [Course] {
		return self.courses.filter({ self.doesMeetOnDate($0, schedule: schedule) })
	}
	
	private func doesMeetOnDate(_ meeting: Course, schedule: Schedule) -> Bool {
		switch meeting.schedule {
		case let .everyDay(block):
			if let block = block {
				if let timetable = schedule.selectedTimetable, timetable.hasBlock(id: block) {
					return true
				}
			}
			return false
		case let .specificDays(block, days):
			if let block = block {
				let day = schedule.dayOfWeek!
				if let timetable = schedule.selectedTimetable {
					if days.contains(day) && timetable.hasBlock(id: block) {
						return true
					}
				}
			}
			return false
		}
	}
	
}
