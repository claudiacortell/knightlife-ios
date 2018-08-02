//
//  MeetingPrefModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/1/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class MeetingPrefModule: StorageHandler {
	
	var storageKey: String = "course.items"
	
	let manager: CourseManager
	
	init(_ manager: CourseManager) {
		self.manager = manager
	}
	
	func saveData() -> Any? {
		return nil
//		return self.manager.meetings
	}
	
	func loadData(data: Any) {
		if let list = data as? [Course] {
			for meeting in list {
				self.manager.addCourse(meeting)
			}
		}
	}
	
	func loadDefaults() {
		self.loadLegacyData()
	}
	
	private func loadLegacyData()
	{
		if let meta = Storage.USER_META.getValue() as? [String:[String:String?]]
		{
			for (rawBlockId, keyPairs) in meta
			{
				if let blockId = BlockID(rawValue: ["A", "B", "C", "D", "E", "F", "G"].firstIndex(of: rawBlockId) ?? 99) {
					let name: String = {
						if keyPairs["name"] != nil
						{ if keyPairs["name"]! != nil
						{ return keyPairs["name"]!! } }; return "Unknown" }()
					let color: String? = { if keyPairs["color"] != nil { if keyPairs["color"]! != nil { return keyPairs["color"]!! } }; return nil }()
					let room: String? = { if keyPairs["room"] != nil { if keyPairs["room"]! != nil { return keyPairs["room"]!! } }; return nil }()
					
					let schedule = CourseSchedule(block: blockId, frequency: .everyDay)
					let course = Course(name: name, schedule: schedule)
					course.location = room
					
					if color != nil, let parsedColor = UIColor(hex: color!) {
						course.color = parsedColor
					}
					
					self.manager.addCourse(course)
				}
			}
		}
	}
}
