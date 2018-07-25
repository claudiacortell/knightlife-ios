//
//  ScheduleVariationStorage.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class ScheduleVariationStorage: StorageHandler {
	
	let manager: ScheduleManager
	
	var storageKey: String {
		return "variation"
	}
	
	init(manager: ScheduleManager) {
		self.manager = manager
	}
	
	func saveData() -> Any? {
		return self.manager.scheduleVariations
	}
	
	func loadData(data: Any) {
		if let items = data as? [DayOfWeek: Int] {
			for (day, val) in items {
				self.manager.loadedVariation(day: day, variation: val)
			}
		}
	}
	
	func loadDefaults() {
		if let switches = Storage.USER_SWITCHES.getValue() as? [String: Bool] {
			for (rawDayId, val) in switches {
				if let dayId = DayOfWeek.fromShortName(shortName: rawDayId) {
					self.manager.loadedVariation(day: dayId, variation: val ? 1 : 0)
				}
			}
		}
	}

}
