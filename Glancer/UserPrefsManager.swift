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
		init(_ blockId: BlockID, _ customColor: String) { self.blockId = blockId; self.customColor = customColor }
		var blockId: BlockID! // E.G. A, B, C, D, E (Corresponds to Class ID)
		var customName: String? // Same as block id by default. Can be changed to reflect user preferences
		var customColor: String!
	}
	
	private var blockMeta: [BlockID: BlockMeta] =
	[
		.a: BlockMeta(.a, "E74C3C"),
		.b: BlockMeta(.b, "E67E22"),
		.c: BlockMeta(.c, "F1C40F"),
		.d: BlockMeta(.d, "2ECC71"),
		.e: BlockMeta(.e, "3498DB"),
		.f: BlockMeta(.f, "9B59B6"),
		.g: BlockMeta(.g, "DE59B6"),
		.x: BlockMeta(.x, "999999"),
		.activities: BlockMeta(.activities, "999999"),
		.custom: BlockMeta(.custom, "999999"),
		.lab: BlockMeta(.lab, "999999")
	]
	
	private var allowMetaChanges: [BlockID] = [ .a, .b, .c, .d, .e, .f, .g ]
	
	private var lunchSwitches: [DayID: Bool] =
	[
		.monday: true,
		.tuesday: true,
		.wednesday: true,
		.thursday: true,
		.friday: true
	]
	
	init()
	{
		self.reloadPrefs()
	}
	
	func getSwitch(id: DayID) -> Bool?
	{
		if let boo = self.lunchSwitches[id]
		{
			return boo
		}
		return nil
	}
	
	func setSwitch(id: DayID, val: Bool)
	{
		self.lunchSwitches[id] = val
		self.savePrefs()
		self.notifyHandlers()
	}
	
	func getMeta(id: BlockID) -> BlockMeta?
	{
		if let meta = self.blockMeta[id]
		{
			return meta
		}
		return nil
	}
	
	func setMeta(id: BlockID, meta: BlockMeta)
	{
		if self.allowMetaChanges.contains(id)
		{
			Debug.out("Allowed!!!!!!")
			
			self.blockMeta[id] = meta
			self.savePrefs()
			self.notifyHandlers()
		}
	}
	
	private func notifyHandlers()
	{
		for handler in self.updateHandlers
		{
			handler.prefsDidUpdate()
		}
	}
	
	func reloadPrefs()
	{
		// get/set values for class names
		if Storage.storageMethodUpdated // Account for old storage method to keep legacy data
		{
			Debug.out("Method updated.")
			
			// Load lunches
			for (dayId, _) in self.lunchSwitches // Iterate through the default day settings for first lunch
			{
				let lunchStorage = Storage.LUNCH_SWITCHES.child(name: dayId.rawValue)
				if lunchStorage.exists()
				{
					if let set = lunchStorage.getValue() as? Bool
					{
						self.lunchSwitches[dayId] = set
					}
				}
			}
			
			// Load blocks
			for (blockId) in self.blockMeta.keys
			{
				Debug.out("------------------------")
				Debug.out("BlockID: \(blockId)")

				if var meta = self.getMeta(id: blockId)
				{
					Debug.out("Meta: \(meta)")

					if !self.allowMetaChanges.contains(blockId) { continue }
					
					Debug.out("Allow meta")

					let metaStorage = Storage.BLOCK_META.child(name: blockId.rawValue)
					let nameStorage = metaStorage.child(name: "name")
					let colorStorage = metaStorage.child(name: "color")
					
					if nameStorage.exists()
					{
						Debug.out("Name storage exists")

						if let parsed = nameStorage.getValue() as? String
						{
							meta.customName = parsed
							Debug.out(parsed)
						}
					}
					
					if colorStorage.exists()
					{
						Debug.out("Color storage exists")

						if let parsed = colorStorage.getValue() as? String
						{
							Debug.out("Got parse! \(parsed)")

							meta.customColor = parsed
							Debug.out(parsed)
						}
					}
					
					self.setMeta(id: blockId, meta: meta)
				}
			}
		} else
		{
			Debug.out("Method not updated.")

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
			
			for i in 0..<8
			{
				let id = BlockID.fromId(i)!
				if var meta = self.getMeta(id: id)
				{
					if classColors.count > i { meta.customColor = classColors[i] }
					if classNames.count > i { meta.customName = classNames[i] }
					
					self.setMeta(id: id, meta: meta)
				}
			}
			
			for i in 0..<5
			{
				let day: DayID = DayID.fromId(i)!
				if lunchSwitches.count > i { lunchSwitches[day] = firstLunches[i] }
			}
			
			Storage.deleteOldMethodRemnants() // Enable when we're ok getting rid of the old storage data.
		}
		
		self.notifyHandlers()
	}
	
	private func savePrefs()
	{
		for (dayId, val) in self.lunchSwitches // Iterate through the default day settings for first lunch
		{
//			Debug.out("Saving: \(dayId), \(val)")
			
			let lunchStorage = Storage.LUNCH_SWITCHES.child(name: dayId.rawValue)
			lunchStorage.set(data: val)
		}
		
		// Load blocks
		for (blockId) in self.blockMeta.keys
		{
			if let meta = self.getMeta(id: blockId)
			{
				if !self.allowMetaChanges.contains(blockId) { continue }
				
				let metaStorage = Storage.BLOCK_META.child(name: blockId.rawValue)
				let nameStorage = metaStorage.child(name: "name")
				let colorStorage = metaStorage.child(name: "color")
				
//				Debug.out("Saving: \(blockId), \(meta.customColor), \(meta.customName)")
				
				if let name = meta.customName
				{
					nameStorage.set(data: "\(name)")
				} else
				{
					nameStorage.delete()
				}
				
				colorStorage.set(data: "\(meta.customColor!)")
			}
		}
		
//		self.reloadPrefs()
	}
}

protocol PrefsUpdateHandler
{
	func prefsDidUpdate()
}
