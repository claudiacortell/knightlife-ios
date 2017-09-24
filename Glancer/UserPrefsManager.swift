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

	private func notifyHandlers(_ type: PrefsUpdateType)
	{
		for handler in self.updateHandlers
		{
			handler.prefsDidUpdate(type)
		}
	}
	
	func addHandler(_ handler: PrefsUpdateHandler)
	{
		updateHandlers.append(handler)
	}
	
	enum PrefsUpdateType
	{
		case meta, lunch, load
	}
	
	struct BlockMeta
	{
		init(_ blockId: BlockID, _ customColor: String) { self.blockId = blockId; self.customColor = customColor }
		var blockId: BlockID! // E.G. A, B, C, D, E (Corresponds to Class ID)
		var customName: String?// Same as block id by default. Can be changed to reflect user preferences
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
	
	private class AccessKeys
	{
		fileprivate static let NAME = "name"
		fileprivate static let COLOR = "color"
	}
	
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
		self.loadPrefs()
	}
	
	func getSwitch(id: DayID) -> Bool?
	{
		if let boo = self.lunchSwitches[id]
		{
			return boo
		}
		return nil
	}
	
	func setSwitch(id: DayID, val: Bool, save: Bool = true)
	{
		self.lunchSwitches[id] = val
		if save { self.saveLunch() }
		self.notifyHandlers(.lunch)
	}
	
	func getMeta(id: BlockID) -> BlockMeta?
	{
		if let meta = self.blockMeta[id]
		{
			return meta
		}
		return nil
	}
	
	func setMeta(id: BlockID, meta: inout BlockMeta, save: Bool = true)
	{
		if self.allowMetaChanges.contains(id)
		{
			if let curMeta = self.blockMeta[id]
			{
				if curMeta.customColor != meta.customColor { Debug.out("Changed \(id.rawValue):Color from \(curMeta.customColor) to \(meta.customColor)") }
				if curMeta.customName != meta.customName { Debug.out("Changed \(id.rawValue):Name from \(curMeta.customName ?? "null") to \(meta.customName ?? "null")") }
			}
			
			if meta.customName != nil && meta.customName!.count <= 0 // Prevent renaming to nothing.
			{
				meta.customName = nil
			}
			
			self.blockMeta[id] = meta
			if save { self.saveMeta() }
			self.notifyHandlers(.meta)
		}
	}
	
	func loadPrefs()
	{
		// get/set values for class names
		if Storage.storageMethodUpdated // Account for old storage method to keep legacy data
		{
			// Load lunches
			if let switches = Storage.USER_SWITCHES.getValue() as? [String: Bool]
			{
				for (rawDayId, val) in switches
				{
					if let dayId = DayID.fromRaw(raw: rawDayId)
					{
						self.setSwitch(id: dayId, val: val, save: false)
					}
				}
			}
			
			if let meta = Storage.USER_META.getValue() as? [String:[String:String?]]
			{
				for (rawBlockId, keyPairs) in meta
				{
					if let blockId = BlockID.fromRaw(raw: rawBlockId)
					{
						if self.allowMetaChanges.contains(blockId)
						{
							if var defaultMeta = self.getMeta(id: blockId)
							{
								for (key, val) in keyPairs
								{
									switch key
									{
									case AccessKeys.NAME:
										if val != nil { defaultMeta.customName = val! }
										break
									case AccessKeys.COLOR:
										if val != nil { defaultMeta.customColor = val! }
										break
									default:
										break
									}
								}
								
								self.setMeta(id: blockId, meta: &defaultMeta, save: false)
							}
						}
					}
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
					
					self.setMeta(id: id, meta: &meta)
				}
			}
			
			for i in 0..<5
			{
				let day: DayID = DayID.fromId(i)!
				if lunchSwitches.count > i { lunchSwitches[day] = firstLunches[i] }
			}
			
			Storage.deleteOldMethodRemnants() // Enable when we're ok getting rid of the old storage data.
		}
		
		self.notifyHandlers(.load)
	}
	
	private func saveLunch()
	{
		Debug.out("Attempting to save lunches...")
		var map: [String:Bool] = [:]
		for (dayId, val) in self.lunchSwitches
		{
			map[dayId.rawValue] = val
		}
		
		Storage.USER_SWITCHES.set(data: map)
		Debug.out("Finished saving lunches...")
	}
	
	private func saveMeta()
	{
		Debug.out("Attempting to save meta...")
		var map: [String:[String:String?]] = [:]
		for (blockId) in self.blockMeta.keys
		{
			if !self.allowMetaChanges.contains(blockId) { continue }

			var keyValMap: [String: String?] = [:]
			
			if let meta = self.getMeta(id: blockId)
			{
				keyValMap[AccessKeys.NAME] = meta.customName == nil ? nil : "\(meta.customName!)"
				keyValMap[AccessKeys.COLOR] = meta.customColor == nil ? nil : "\(meta.customColor!)"
			}
			
			map[blockId.rawValue] = keyValMap
		}
		
		Storage.USER_META.set(data: map)
		Debug.out("Finished saving meta...")
	}
}

protocol PrefsUpdateHandler
{
	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
}
