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
		return "schedule.variation"
	}
	
	init(manager: ScheduleManager) {
		self.manager = manager
	}
	
	func saveData() -> Any? {
		let variations = self.manager.scheduleVariations
		
		var newMap: [String: Int] = [:]
		for (day, variation) in variations {
			newMap[day.shortName] = variation
		}
		return newMap
	}
	
	func loadData(data: Any) {
		if let items = data as? [String: Int] {
			for (day, val) in items {
				guard let dayId = DayOfWeek(shortName: day) else {
					print("Couldn't parse dayId for variation: \(day)")
					continue
				}
				
				self.manager.loadedVariation(day: dayId, variation: val)
			}
		}
	}
	
	func loadDefaults() {
//		if let switches = Storage.USER_SWITCHES.getValue() as? [String: Bool] {
//			print(switches)
//			for (rawDayId, val) in switches {
//				if let dayId = DayOfWeek(shortName: rawDayId) {
//					self.manager.loadedVariation(day: dayId, variation: val ? 1 : 0)
//				}
//			}
//			
//			Storage.USER_SWITCHES.delete()
//		}
	}

}
