//
//  NotificationStorage.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/5/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class NotificationStorage: StorageHandler {
	
	var storageKey: String = "notifications.cache"
	
	let manager: NotificationManager
	
	init(manager: NotificationManager) {
		self.manager = manager
	}
	
	func loadData(data: Any) {
		
	}
	
	func saveData() -> Any? {
		return nil
	}
	
	func loadDefaults() {
		
	}
	
}
