//
//  MapModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class MapModule<ModuleManager: Manager, Key: Hashable, Value>: Module<ModuleManager>
{
	var items: [Key: Value]
	
	init(_ manager: ModuleManager, name: String, list: [Key: Value])
	{
		self.items = list
		super.init(manager, name: name)
	}
	
	override init(_ manager: ModuleManager, name: String)
	{
		self.items = [:]
		super.init(manager, name: name)
	}
	
	func addItem(_ key: Key, _ value: Value, ignoreDuplicates: Bool = false)
	{
		self.items[key] = value
	}
	
	func removeItem(_ key: Key, duplicates: Bool = true)
	{
		self.items[key] = nil
	}
	
	func hasItem(_ key: Key) -> Bool
	{
		return self.getItem(key) != nil
	}
	
	func getItem(_ key: Key) -> Value?
	{
		return self.items[key]
	}
}
