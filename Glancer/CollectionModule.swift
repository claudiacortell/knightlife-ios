//
//  CollectionModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/8/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class CollectionModule<ModuleManager: Manager, Target: Hashable>: Module<ModuleManager>
{
	var items: [Target]
	
	init(_ manager: ModuleManager, name: String, list: [Target])
	{
		self.items = list
		super.init(manager, name: name)
	}
	
	override init(_ manager: ModuleManager, name: String)
	{
		self.items = []
		super.init(manager, name: name)
	}
	
	func containsItem(_ target: Target) -> Bool
	{
		return self.items.contains(target)
	}
	
    @discardableResult
	func addItem(_ target: Target, ignoreDuplicates: Bool = false) -> Bool
	{
		if !containsItem(target) || !ignoreDuplicates
		{
			self.items.append(target)
			return true
		}
		return false
	}
	
    @discardableResult
	func removeItem(_ target: Target, duplicates: Bool = true) -> (success: Bool, count: Int)
	{
		var removed = 0
		if containsItem(target)
		{
			while containsItem(target)
			{
				for i in 0..<self.items.count
				{
					if self.items[i] == target
					{
						self.items.remove(at: i)
						
						if !duplicates
						{
							return (success: true, count: 1)
						}
						
						removed += 1
						break
					}
				}
			}
		}
		
		return (success: removed > 0, count: removed)
	}
}
