//
//  SportsPrefModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

class SportsPrefModule: CollectionModule<SportsManager, SportTeam>, PrefsHandler {
	
	var storageKey: String { return self.nameComplete }

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
				if let team = manager.getTeamById(id: id) {
					self.addItem(team, ignoreDuplicates: true)
					out("Loaded user added: \(team)")
				}
			}
		}
	}
	
	func loadDefaults() {
		
	}
	
}
