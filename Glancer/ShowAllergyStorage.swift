//
//  ShowAllergyStorage.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/31/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class ShowAllergyStorage: StorageHandler {
	
	let manager: LunchManager
	
	var storageKey: String = "lunch.show-allergy"
	
	init(manager: LunchManager) {
		self.manager = manager
	}
	
	func saveData() -> Any? {
		return manager.showAllergens
	}
	
	func loadData(data: Any) {
		guard let val = data as? Bool else {
			self.loadDefaults()
			return
		}
		
		self.manager.loadedShowAllergens(value: val)
	}
	
	func loadDefaults() {
		self.manager.loadedShowAllergens(value: true)
	}
	
}
