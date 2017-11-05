//
//  SportsPrefModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class SportsPrefModule: ListPrefsModule
{
	typealias Target = SportTeam
	typealias PrefsManager = SportsManager
	
	var storageKey: String = "addedteams"
	var manager: SportsManager
	var items: [SportTeam]
	
	init(_ manager: SportsManager)
	{
		self.manager = manager
		self.items = []
	}
	
	func getStorageValues() -> Any?
	{
		var list: [Int] = []
		for team in self.items
		{
			if !list.contains(team.id)
			{
				list.append(team.id)
			}
		}
		return list
	}
	
	func readStorageValues(data: Any)
	{
		if let list = data as? [Int]
		{
			for id in list
			{
				if let team = manager.getTeamById(id: id)
				{
					if !self.items.contains(team)
					{
						self.items.append(team)
						print("Loaded user added: \(team)")
					}
				}
			}
		}
	}
	
	func containsItem(_ target: SportTeam) -> Bool
	{
		return self.items.contains(target)
	}
	
	func addItem(_ target: SportTeam, ignoreDuplicates: Bool) -> Bool
	{
		if ignoreDuplicates && self.containsItem(target)
		{
			return false
		}
		self.items.append(target)
		return true
	}
	
	func removeItem(_ target: SportTeam) -> Bool
	{
		if !self.containsItem(target)
		{
			return false
		}
		for i in self.items.indices
		{
			if self.items[i] == target
			{
				self.items.remove(at: i)
				return true
			}
		}
		return false
	}
}
