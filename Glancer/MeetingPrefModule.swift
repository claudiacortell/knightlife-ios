//
//  MeetingPrefModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/1/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import RealmSwift

class MeetingPrefModule: StorageHandler {
	
	var storageKey: String = "course.items"
	
	let manager: CourseManager
	
	init(_ manager: CourseManager) {
		self.manager = manager
	}
	
	func saveData() -> Any? {
//		var arrayOfData: [[String: Any]] = []
//
//		for course in self.manager.meetings {
//			var map: [String: Any] = [:]
//
//			map["name"] = course.name
//
//			map["color"] = course.color.toHex ?? nil
//			map["location"] = course.location
//
//			map["notifications"] = course.showBeforeClassNotifications
//			map["notifications_after"] = course.showAfterClassNotifications
//
//			map["schedule.block"] = course.courseSchedule.block.rawValue
//
//			switch course.courseSchedule.frequency {
//			case .everyDay:
//				map["schedule.frequency"] = "everyday"
//			case .specificDays(let days):
//				map["schedule.frequency"] = days.map({ return $0.rawValue })
//			}
//
//			arrayOfData.append(map)
//		}
//
//		return arrayOfData
		return nil
	}
	
	func loadData(data: Any) {
		guard let list = data as? [[String: Any]] else {
			return
		}
		
		for item in list {
			guard let name = item["name"] as? String else {
				print("Invalid course name")
				continue
			}
			
			var location: String?
			if let rawLocation = item["location"] as? String {
				location = rawLocation
			}
			
			guard let rawColor = item["color"] as? String, let color = UIColor(hex: rawColor) else {
				print("Invalid course color")
				continue
			}
			
			guard let beforeClassNotifications = item["notifications"] as? Bool else {
				print("Invalid course notifications")
				continue
			}
			
			guard let rawBlock = item["schedule.block"] as? Int, let block = Block.ID(index: rawBlock) else {
				print("Invalid course block")
				continue
			}
			
			var frequency: Int = 0
			var days: [Int] = []
			
			if let _ = item["schedule.frequency"] as? String {
				frequency = 0
			} else if let rawFrequencyDays = item["schedule.frequency"] as? [Int] {
//				We could easily use a simple map function, but that would require force unwrapping, and I don't want to have the option of a crash.
				
				frequency = 1
				days = rawFrequencyDays
			} else {
				print("Invalid course frequency")
				continue
			}
			
			
			let course = Course()

			course._scheduleFrequency = frequency
			course._scheduleBlock = block.rawValue
			
			course._meetingDays = List<Int>()
			course._meetingDays.append(objectsIn: days)
			
			course._beforeClassNotifications = beforeClassNotifications
			
			course._name = name
			course._color = color.toHex!
			
			course._location = location
			
			if let afterClassNotifications = item["notifications_after"] as? Bool {
				course._afterClassNotifications = afterClassNotifications
			}
			
			self.manager.loadLegacyCourse(course: course)
		}
	}
	
	func loadDefaults() {
//		self.loadLegacyData()
	}
	
//	private func loadLegacyData()
//	{
//		if let meta = Storage.USER_META.getValue() as? [String:[String:String?]]
//		{
//			for (rawBlockId, keyPairs) in meta
//			{
//				if let blockId = Block.ID(rawValue: ["A", "B", "C", "D", "E", "F", "G"].index(of: rawBlockId) ?? 99) {
//					let name: String = {
//						if keyPairs["name"] != nil
//						{ if keyPairs["name"]! != nil
//						{ return keyPairs["name"]!! } }; return "Unknown" }()
//					let color: String? = { if keyPairs["color"] != nil { if keyPairs["color"]! != nil { return keyPairs["color"]!! } }; return nil }()
//					let room: String? = { if keyPairs["room"] != nil { if keyPairs["room"]! != nil { return keyPairs["room"]!! } }; return nil }()
//
//					let schedule = CourseSchedule(block: blockId, frequency: .everyDay)
//					let course = Course(name: name, schedule: schedule)
//					course.location = room
//
//					if color != nil, let parsedColor = UIColor(hex: color!) {
//						course.color = parsedColor
//					}
//
//					self.manager.addCourse(course)
//				}
//			}
//
//			Storage.USER_META.delete()
//		}
//	}
}
