//
//  UserPrefs.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class UserPrefsManager
{
	static let instance = UserPrefsManager()
	
	private var updateHandlers: [PrefsUpdateHandler] = []

	func addHandler(_ handler: PrefsUpdateHandler)
	{
		updateHandlers.append(handler)
	}
	
	struct BlockMeta
	{
		init(_ blockId: BlockID, _ customColor: String) { self.blockId = blockId; self.customName = blockId.rawValue; self.customColor = customColor }
		var blockId: BlockID! // E.G. A, B, C, D, E (Corresponds to Class ID)
		var customName: String! { didSet { UserPrefsManager.instance.metaNameChanged(self) } } // Same as block id by default. Can be changed to reflect user preferences
		var customColor: String! { didSet { UserPrefsManager.instance.metaColorChanged(self) } }
	}
	
	var blockMeta: [BlockID: BlockMeta] =
	[
		.a: BlockMeta(.a, "E74C3C"),
		.b: BlockMeta(.b, "E67E22"),
		.c: BlockMeta(.c, "F1C40F"),
		.d: BlockMeta(.d, "2ECC71"),
		.e: BlockMeta(.e, "3498DB"),
		.f: BlockMeta(.f, "9B59B6"),
		.g: BlockMeta(.g, "DE59B6"),
		.x: BlockMeta(.x, "999999")
	]
	
	var lunchSwitches: [DayID: Bool] =
	[
		.monday: true,
		.tuesday: true,
		.wednesday: true,
		.thursday: true,
		.friday: true
	] {
		didSet { UserPrefsManager.instance.lunchSwitchChanged()}
	} // Day Id: On/Off
	
	private func metaNameChanged(_ meta: BlockMeta)
	{
		notifyHandlers()
		// TODO Set name
	}
	
	private func metaColorChanged(_ meta: BlockMeta)
	{
		notifyHandlers()
		// TODO Set color
	}
	
	private func lunchSwitchChanged()
	{
		notifyHandlers()
		// TODO Set lunch switch
	}
	
	private func notifyHandlers()
	{
		for handler in self.updateHandlers
		{
			handler.prefsDidUpdate(manager: self)
		}
	}
	
	func reloadPrefs()
	{
		/*
		M  T  W  TH  F  SA  SU
		0  1  2  3   4  5   6
		*/
		
		// get/set values for class names
		if Storage.storageMethodUpdated // Account for old storage method to keep legacy data
		{
			// Retrieve shit
			
			
			// TODO
			
			
		} else
		{
			// get/set values for custom class names
			var classNames = [String]() // 7 of these (7 class blocks)
			if Storage.OLD_CLASS_NAMES.exists()
			{
				classNames = Storage.OLD_CLASS_NAMES.getValue() as! [String]
			}
			
			// get/set values for lunch boolean settings
			var firstLunches = [Bool]() // 5 of these (5 weekdays)
			if Storage.OLD_FIRSTLUNCH_VALUES.exists()
			{
				firstLunches = Storage.OLD_FIRSTLUNCH_VALUES.getValue() as! [Bool]
			}
			
			// get/set values for class color selection
			var classColors = [String]() // 7 of these (7 class blocks)
			if Storage.OLD_COLOR_IDS.exists()
			{
				classColors = Storage.OLD_COLOR_IDS.getValue() as! [String]
			}
			
			for i in 0..<7
			{
				var meta: BlockMeta = self.blockMeta[BlockID.fromId(i)!]!
				if classColors.count > i { meta.customColor = classColors[i] }
				if classNames.count > i { meta.customName = classNames[i] }
			}
			
			for i in 0..<5
			{
				let day: DayID = DayID.fromId(i)!
				if lunchSwitches.count > i { lunchSwitches[day] = firstLunches[i] }
			}
			
			Storage.deleteOldMethodRemnants() // This removes the aforementioned previous 3 values from storage
			
//			// get/set values for class notes
//			var classNotes = [String]()
//			if (defaults.object(forKey: "NoteTexts") != nil) {
//				classNotes = defaults.object(forKey: "NoteTexts") as! Array<String>
//			} else {
//				var count = 0
//				while count < 8 {
//					classNotes.append("")
//					count += 1
//				}
//				defaults.set(classNotes, forKey: "NoteTexts")
//			}
		}
		
		// Set up Lunch blocks for first and second lunch
		for dayIndex in ScheduleManager.instance.weekSchedule.keys
		{
			var day = ScheduleManager.instance.weekSchedule[dayIndex]!
			let firstLunch: Bool = self.lunchSwitches[day.dayId]!
			
			for blockIndex in day.blocks.keys
			{
				var block = day.blocks[blockIndex]!
				
				if (block.isLunchBlock)
				{															// E.G. B1 or B2 (Is a lunch block)
					if (firstLunch && block.lunchBlockNumber! == 1) // First lunch
					{
						block.overrideDisplayName = "Lunch"
					} else if (!firstLunch && block.lunchBlockNumber! == 2) // Second lunch
					{
						block.overrideDisplayName = "Lunch"
					} else
					{
						block.overrideDisplayName = block.blockId.rawValue
					}
				}
			}
		}
	}
}

protocol PrefsUpdateHandler
{
	func prefsDidUpdate(manager: UserPrefsManager)
}
