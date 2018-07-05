//
//  SportsPrefModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class SportsPrefModule: StorageHandler {
	
	let manager: SportsManager
	var storageKey: String { return "sports" }
	
	var items: [SportTeam] = []
	
	init(_ manager: SportsManager) {
		self.manager = manager
	}

	func saveData() -> Any? {
		var list: [Int] = []
		for team in self.items {
			if !list.contains(team.id) {
				list.append(team.id)
			}
		}
		return list
	}
	
	func loadData(data: Any) {
		if let list = data as? [Int] {
			for id in list {
				if let team = self.manager.getTeamById(id: id) {
					self.items.append(team)
					self.manager.out("Loaded user added: \(team)")
				}
			}
		}
	}
	
	func loadDefaults() {
		
	}
	
}
