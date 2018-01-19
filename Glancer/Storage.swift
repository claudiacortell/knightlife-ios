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
	static var hasUpdatedDirectories: Bool
	{
		return suiteDefaults.object(forKey: USER_META.key) != nil
	}
	
	static func setToSuiteDefaults()
	{
		self.defaults = self.suiteDefaults
	}
	
	static let USER_SWITCHES = StorageKey("userswitches")
	static let USER_META = StorageKey("usermeta")
	
	private static let directory = "group.KnightLife.MAD.Widget"
	private static let suiteDefaults = UserDefaults(suiteName: directory)!
	private static var defaults = UserDefaults.standard
	
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
		return StorageKey("\(self.key)_\(name)")
	}
	
	func delete()
	{
		Storage.delete(self)
	}
}
