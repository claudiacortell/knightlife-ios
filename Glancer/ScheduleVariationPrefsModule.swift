//
//  ModuleScheduleVariation.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

class ScheduleVariationPrefsModule: MapModule<ScheduleManager, Day, Int>, PrefsHandler {
	
	var storageKey: String {
		return self.nameComplete
	}
	
	func saveData() -> Any? {
		return self.items
	}
	
	func loadData(data: Any) {
		if let items = data as? [Day: Int] {
			for (day, val) in items {
				self.addItem(day, val)
			}
		}
	}
	
	func loadDefaults() {
		if let switches = Storage.USER_SWITCHES.getValue() as? [String: Bool] {
			for (rawDayId, val) in switches {
				if let dayId = Day.fromRaw(raw: rawDayId) {
					self.addItem(dayId, val ? 1 : 0)
				}
			}
		}
	}

}
