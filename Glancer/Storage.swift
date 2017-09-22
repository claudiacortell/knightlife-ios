//
//  Storage.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class Storage
{
	//	Wrapper class for settings. Makes it easy to check settings.
	static let DB_SAVED = StorageKey("SavedToDB")
	
	static let OLD_CLASS_NAMES = StorageKey("ButtonTexts")
	static let OLD_FIRSTLUNCH_VALUES = StorageKey("SwitchValues")
	static let OLD_COLOR_IDS = StorageKey("ColorIDs")
	
	static let NEW_CLASS_NAMES = StorageKey("ClassName")
	static let NEW_FIRSTLUNCH_VALUES = StorageKey("FirstLunch")
	static let NEW_COLOR_IDS = StorageKey("BlockColor")
	
	
//	------------------------------------------------------------------------------------------
// This is used while switching from their old data storage system to my new one. If this whole system is removed then users who haven't updated (to the new version as of September 14 2017) will have their prefs wiped which isn't the end of the world i guess. This can all be deleted at some point. It's just to phase the active users into the new system which consists of better labeled hierchy and key:value pairs.

	static var storageMethodUpdated: Bool
	{
		get
		{
			return !(OLD_CLASS_NAMES.exists() || OLD_FIRSTLUNCH_VALUES.exists() || OLD_COLOR_IDS.exists()) // If one of the old data value keys exists then it hasn't been updated
		}
	}
	
	static func deleteOldMethodRemnants()
	{
		OLD_CLASS_NAMES.delete()
		OLD_FIRSTLUNCH_VALUES.delete()
		OLD_COLOR_IDS.delete()
	}
//	------------------------------------------------------------------------------------------

	private static let directory = "group.vishnu.squad.widget"
	private static let defaults = UserDefaults.standard
	
	static func has(_ key: String) -> Bool
	{
		return Storage.defaults.object(forKey: key) != nil
	}
	
	static func get(_ key: String) -> Any?
	{
		return Storage.defaults.object(forKey: key)
	}
	
	static func set(_ key: String, data: Any?)
	{
		Storage.defaults.set(data, forKey: key)
	}
	
	static func delete(_ key: String)
	{
		Storage.defaults.removeObject(forKey: key)
	}
	
	static func has(_ key: StorageKey) -> Bool
	{
		return Storage.has(key.key)
	}
	
	static func get(_ key: StorageKey) -> Any?
	{
		return Storage.get(key.key)
	}
	
	static func set(_ key: StorageKey, data: Any?)
	{
		Storage.set(key.key, data: data)
	}
	
	static func delete(_ key: StorageKey)
	{
		Storage.delete(key.key)
	}
}

class StorageKey
{
	let key: String
	
	init(_ key: String)
	{
		self.key = key
	}
	
	func exists() -> Bool
	{
		return Storage.has(self)
	}
	
	func getValue() -> Any?
	{
		return Storage.get(self)
	}
	
	func set(data: Any?)
	{
		Storage.set(self, data: data)
	}
	
	func child(name: String) -> StorageKey
	{
		return StorageKey("\(self.key).\(name)")
	}
	
	func delete()
	{
		Storage.delete(self)
	}
}
