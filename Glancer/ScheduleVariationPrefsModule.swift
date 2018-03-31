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
	
	func loadDefaultValues()
	{
		loadLegacyData()
	}
	
	private func loadLegacyData()
	{
		if let switches = Storage.USER_SWITCHES.getValue() as? [String: Bool]
		{
			for (rawDayId, val) in switches
			{
				if let dayId = DayID.fromRaw(raw: rawDayId)
				{
					self.addItem(dayId, val ? 1 : 0)
				}
			}
		}
	}
}
