//
//  Course.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Signals

class Course: Object {
	
	let onUpdate = Signal<Void>()
	
	@objc dynamic var uid: String = UUID().uuidString
	
	override static func primaryKey() -> String {
		return "uid"
	}
	
	@objc dynamic var _name: String = ""
	@objc dynamic var _location: String? = nil
	@objc dynamic var _color: String? = nil
	
	let onBeforeClassNotificationsUpdate: Signal<Bool> = Signal<Bool>()
	@objc dynamic var _beforeClassNotifications: Bool = true
	
	let onAfterClassNotificationsUpdate: Signal<Bool> = Signal<Bool>()
	@objc dynamic var _afterClassNotifications: Bool = false
	
	// MARK: Schedule
	
	let onScheduleChange = Signal<CourseSchedule?>()
	
	@objc dynamic var _scheduleFrequency: Int = 0
	@objc dynamic var _scheduleBlock: String? = nil

	var _meetingDays: List<Int> = List<Int>()
	
	func delete() {
		if self.isInvalidated {
			return
		}
		
		CourseM.deleteCourse(course: self)
		
		self.onUpdate.fire()
		self.onScheduleChange.fire(self.schedule)
		CourseM.onMeetingUpdate.fire(self)
	}
	
}

extension Course {
	
	var name: String {
		get {
			return self._name
		}
		
		set {
			try! Realms.write {
				self._name = newValue
			}
			
			self.onUpdate.fire()
			CourseM.onMeetingUpdate.fire(self)
		}
	}
	
	var location: String? {
		get {
			return self._location
		}
		
		set {
			try! Realms.write {
				self._location = newValue
			}
			
			self.onUpdate.fire()
			CourseM.onMeetingUpdate.fire(self)
		}
	}
	
	var color: UIColor {
		get {
			return UIColor(hex: self._color ?? "") ?? Scheme.nullColor.color
		}
		
		set {
			try! Realms.write {
				self._color = newValue.toHex
			}
			
			self.onUpdate.fire()
			CourseM.onMeetingUpdate.fire(self)
		}
 	}
	
	var beforeClassNotifications: Bool {
		get {
			return self._beforeClassNotifications
		}
		
		set {
			try! Realms.write {
				self._beforeClassNotifications = newValue
			}
			
			self.onUpdate.fire()
			self.onBeforeClassNotificationsUpdate.fire(self._beforeClassNotifications)
			CourseM.onMeetingUpdate.fire(self)
		}
	}

	var afterClassNotifications: Bool {
		get {
			return self._afterClassNotifications
		}
		
		set {
			try! Realms.write {
				self._afterClassNotifications = newValue
			}
			
			self.onUpdate.fire()
			self.onAfterClassNotificationsUpdate.fire(self._afterClassNotifications)
			CourseM.onMeetingUpdate.fire(self)
		}
	}

	var scheduleBlock: Block.ID? {
		get {
			return Block.ID(rawValue: self._scheduleBlock ?? "")
		}
		
		set {
			try! Realms.write {
				self._scheduleBlock = newValue == nil ? nil : newValue!.rawValue
			}
			
			self.onUpdate.fire()
			self.onScheduleChange.fire(self.schedule)
			CourseM.onMeetingUpdate.fire(self)
		}
	}
	
	var meetingDays: [DayOfWeek] {
		get {
			return self._meetingDays.map({ DayOfWeek(rawValue: $0)! })
		}
		
		set {
			try! Realms.write {
				self._meetingDays.removeAll()
				self._meetingDays.append(objectsIn: newValue.map({ $0.rawValue }))
			}
			
			self.onUpdate.fire()
			self.onScheduleChange.fire(self.schedule)
			CourseM.onMeetingUpdate.fire(self)
		}
	}

	var schedule: CourseSchedule {
		get {
			switch self._scheduleFrequency {
			case 0: // Every day
				return CourseSchedule.everyDay(self.scheduleBlock)
			case 1: // Specific days
				return CourseSchedule.specificDays(self.scheduleBlock, self.meetingDays)
			default: // Return every day
				return CourseSchedule.everyDay(self.scheduleBlock)
			}
		}
		
		set {
			try! Realms.write {
				self._scheduleFrequency = newValue.intValue
				
				switch newValue {
				case .everyDay(let id):
					self._scheduleBlock = id == nil ? nil : id!.rawValue
					
				case .specificDays(let id, let days):
					self._scheduleBlock = id == nil ? nil : id!.rawValue
					
					self._meetingDays.removeAll()
					self._meetingDays.append(objectsIn: days.map({ $0.rawValue }))
				}
			}
			
			self.onUpdate.fire()
			self.onScheduleChange.fire(self.schedule)
			CourseM.onMeetingUpdate.fire(self)
		}
	}
	
}
