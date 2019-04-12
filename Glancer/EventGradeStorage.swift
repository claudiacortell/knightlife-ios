//
//  EventGradeStorage.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/11/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class EventGradeStorage: StorageHandler {
	
	var storageKey: String = "events.grade"
	var manager: EventManager
	
	init(manager: EventManager) {
		self.manager = manager
	}
	
	func loadData(data: Any) {
		if let flag = data as? Int, let grade = Grade(rawValue: flag) {
			self.manager.loadedGrade(grade: grade)
		} else {
			self.manager.loadedGrade(grade: nil)
		}
	}
	
	func saveData() -> Any? {
		return self.manager.userGrade == nil ? nil : self.manager.userGrade!.rawValue
	}
	
	func loadDefaults() {
		self.manager.loadedGrade(grade: nil)
	}
	
}
