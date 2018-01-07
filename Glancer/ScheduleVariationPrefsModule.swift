//
//  ModuleScheduleVariation.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class ScheduleVariationPrefsModule: MapModule<ScheduleManager, DayID, Int>, PreferenceHandler
{
	var storageKey: String
	{
		return self.nameComplete
	}

	func getStorageValues() -> Any?
	{
		return self.items
	}
	
	func readStorageValues(data: Any)
	{
		if let items = data as? [DayID: Int]
		{
			self.items = items
		}
	}
}
