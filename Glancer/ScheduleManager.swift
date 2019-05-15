//
//  ScheduleManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/15/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import AddictiveLib

extension DefaultsKeys {
	
	fileprivate static let scheduleMigratedToMeta = DefaultsKey<Bool>("migrated.schedule")
	
}

class ScheduleManager {
	
	func loadLegacyData() {
		if !Defaults[.scheduleMigratedToMeta] {
			let oldStorage = ScheduleVariationStorage(manager: self)
			StorageHub.instance.loadPrefs(oldStorage)
			
			Defaults[.scheduleMigratedToMeta] = true
		}
	}
	
	func loadLegacyVariation(day: DayOfWeek, variation: Int) {
		Schedule.firstLunches[day] = variation == 1 ? true : false
		
		print("Loaded legacy variation for \( day )")
	}
	
}
