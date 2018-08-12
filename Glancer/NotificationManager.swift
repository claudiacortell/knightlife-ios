//
//  NotificationManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/5/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UserNotifications

class NotificationManager: Manager {
	
	static let instance = NotificationManager()
	
	init() {
		super.init("Notification")
		
		self.registerStorage(NotificationStorage(manager: self))
	}
	
	private func setupNotificationsFromTemplate(date: Date) {
		
	}
	
}
