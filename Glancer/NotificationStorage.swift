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
	
	let formatter: DateFormatter = {
		let formatter = Date.normalizedFormatter
		formatter.dateStyle = DateFormatter.Style.full
		formatter.timeStyle = DateFormatter.Style.full
		return formatter
	}()
	
	init(manager: NotificationManager) {
		self.manager = manager
	}
	
	func loadData(data: Any) {
		guard let data = data as? [[String: Any]] else {
			return
		}
		
		for notification in data {
			guard let id = notification["id"] as? String else {
				continue
			}
			
			guard let rawDate = notification["date"] as? String, let date = self.formatter.date(from: rawDate) else {
				continue
			}
			
			self.manager.loadedNotification(notification: KLNotification(id: id, date: date))
		}
	}
	
	func saveData() -> Any? {
		// Date -> [Notification data]
		var data: [[String: Any]] = []
		
		let notifications = self.manager.scheduledNotifications
		for notification in notifications {
			var notificationData: [String: Any] = [:]
			
			notificationData["id"] = notification.id
			notificationData["date"] = self.formatter.string(from: notification.date)
			
			data.append(notificationData)
		}
		return data
	}
	
	func loadDefaults() {
		
	}
	
}
