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
		guard let package = data as? [String: Any] else {
			return
		}
		
		let firstLoad = (package["legacy"] as? Bool) ?? true // Default to true meaning this hasn't been loaded before
		if firstLoad {
			self.manager.needsToClearLegacyNotifications()
		}
		
		guard let data = package["data"] as? [[String: Any]] else {
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
		
		return [
			"data": data,
			"legacy": false // Set this to false so the app never thinks this is the first load again. This is used to clear existing local notifications
		]
	}
	
	func loadDefaults() {
		self.manager.needsToClearLegacyNotifications()
	}
	
}
