//
//  ModuleScheduleVariation.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class ScheduleVariationPrefsModule: StorageHandler {
	
	var storageKey: String {
		return "variations"
	}
	
	var items: [Day: Int] = [:]
	
	func saveData() -> Any? {
		return self.items
	}
	
	func loadData(data: Any) {
		if let items = data as? [Day: Int] {
			for (day, val) in items {
				self.items[day] = val
			}
		}
	}
	
	func loadDefaults() {
		if let switches = Storage.USER_SWITCHES.getValue() as? [String: Bool] {
			for (rawDayId, val) in switches {
				if let dayId = Day.fromRaw(raw: rawDayId) {
					self.items[dayId] = val ? 1 : 0
				}
			}
		}
	}

}
