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

class KLNotification {

	let id: String
	let date: Date
	
	init(date: Date) {
		self.id = UUID().uuidString
		self.date = date
	}
	
	init(id: String, date: Date) {
		self.id = id
		self.date = date
	}

}

fileprivate class FirstLoadStorage: StorageHandler {
	
	var storageKey: String = "notifications.clearlegacy"
	let manager: NotificationManager
	
	init(manager: NotificationManager) {
		self.manager = manager
	}
	
	func saveData() -> Any? {
		return true
	}
	
	func loadData(data: Any) {
		
	}
	
	func loadDefaults() {
		self.manager.needsToClearLegacyNotifications()
	}
	
}

class NotificationManager: Manager, PushRefreshListener {
	
	let projection = 8 // Schedule 8 days into the future. This could be extended except iOS only allows 64 schedule local notifications
	let shallowProjection = 3
	
	let allowedNotificationCount = 60 // Leave 4 room just to be safe.
	
	var refreshListenerType: [PushRefreshType] = [.SCHEDULE, .NOTIFICATIONS]
	
	static let instance = NotificationManager()
	var hub: UNUserNotificationCenter { return UNUserNotificationCenter.current() }

	let dispatchQueue = DispatchQueue(label: "notification registry") // Ensure that tasks are performed sequentially
	var currentDispatchItem: DispatchWorkItem?
	
//	Data
	private(set) var scheduledNotifications: [KLNotification] = []
	
//	Downloaded Specials
	private(set) var specialSchedules: [Schedule]?
	private(set) var specialSchedulesError: Error?
	var specialSchedulesLoaded: Bool {
		return self.specialSchedules != nil || self.specialSchedulesError != nil
	}
	
//	Downloaded template
	private(set) var template: [DayOfWeek: DaySchedule]?
	private(set) var templateError: Error?
	var templateLoaded: Bool {
		return self.template != nil || self.templateError != nil
	}
	
	init() {
		super.init("Notification")
		
		self.registerListeners()
		self.fetchSpecialSchedules()
		
		self.registerStorage(FirstLoadStorage(manager: self)) // Calls the needs to clear legacy notifications thing
		self.registerStorage(NotificationStorage(manager: self))
//		self.cleanExpired()
	}
	
	private func registerListeners() {
		PushNotificationManager.instance.addListener(type: .REFRESH, listener: self)
		
		ScheduleManager.instance.templateWatcher.onSuccess(self) {
			self.template = $0
			self.templateError = nil
			
			self.scheduleNotifications(daysAhead: self.projection)
		}
		
		ScheduleManager.instance.templateWatcher.onFailure(self) {
			self.templateError = $0
			self.template = nil
		}
		
		ScheduleManager.instance.scheduleVariationUpdatedWatcher.onSuccess(self) {
			tuple in
			self.scheduleShallowNotifications() // Only schedule for 2 day ahead when settings are changed. This means if the user changes a lot at once, the system won't get too bogged down.
		}
		
		TodayManager.instance.nextDayWatcher.onSuccess(self) {
			date in
			
			self.hub.removeAllDeliveredNotifications()
			self.scheduleNotifications(daysAhead: self.projection) // When the day changes, reschedule all our notifications!
		}
	}
	
	func needsToClearLegacyNotifications() {
//		Called when this first loads.
		print("Removing legacy notifications.")
		
		UIApplication.shared.cancelAllLocalNotifications()
		self.saveStorage()
	}
	
	func loadedNotification(notification: KLNotification) {
		self.scheduledNotifications.append(notification)
	}
	
	private func validateNotificationCount() -> Bool {
		return self.scheduledNotifications.count < self.allowedNotificationCount
	}
	
//	This is decently unnecessary, but I'm going to keep it here in case we ever fine tune this Manager in the future so it isn't so intensive.
	func cleanExpired() {
//		let now = Date.today
//		self.scheduledNotifications.removeAll(where: { $0.date < now })
	}
	
	func unregisterAll() {
//		let ids = self.scheduledNotifications.map({ $0.id })
		
//		self.hub.removePendingNotificationRequests(withIdentifiers: ids)
		self.hub.removeAllPendingNotificationRequests() // This will nuke even the locally scheduled ones that we don't want to remove, but atm I'm getting double notifications and this seems to be the best option.
		
		self.scheduledNotifications.removeAll()
		self.saveStorage()
	}
	
	func saveNotification(notification: KLNotification) {
		let debug: Bool? = Globals.getData("debug")
		if (debug ?? false) {
			self.out("Saved notification at date: \(notification.date.webSafeDate) \(notification.date.webSafeTime)")
		}
		
		self.scheduledNotifications.append(notification)
	}
	
	func scheduleShallowNotifications() {
		self.scheduleNotifications(daysAhead: self.shallowProjection)
	}
	
	private func scheduleNotifications(daysAhead: Int, queue: DispatchGroup? = nil) {
		self.out("Registering notifications with projection: \(daysAhead)")
		
		if !self.templateLoaded {
			self.out("Couldn't schedule notifications: template not downloaded")
			return
		}
		
		guard let template = self.template else {
			self.out("Couldn't schedule notifications: no template present")
			return
		}
		
		if !self.specialSchedulesLoaded {
			self.out("Couldn't schedule notifications: Special Schedules not downloaded.")
			return
		}
		
		guard let specialSchedules = self.specialSchedules else {
			self.fetchSpecialSchedules()
			
			self.out("Couldn't schedule notifications: no special schedules present")
			return
		}
		
//		Cancel other active tasks. Schedule our own DispatchItem to handle the scheduling of the notifications.
		if let otherActiveDispatchItem = self.currentDispatchItem {
			otherActiveDispatchItem.cancel()
			self.currentDispatchItem = nil
		}

		var dispatchItem: DispatchWorkItem!
		dispatchItem = DispatchWorkItem() {
			let selfItem = dispatchItem!
		
			self.unregisterAll() // unregister all previous notifications.
			
			let today = Date.today
			
			for i in 0..<daysAhead {
				if selfItem.isCancelled {
					return
				}
				
				let offsetDate = today.dayInRelation(offset: i)
				
				var schedule: Schedule!
				
				//				If there's a special schedule
				if let specialSchedule = specialSchedules.filter({ $0.date.webSafeDate == offsetDate.webSafeDate }).first {
					schedule = specialSchedule
				} else if let templateSchedule = template[offsetDate.weekday] {
					let dateSchedule = Schedule(date: offsetDate, day: nil, changed: false, notices: [], blocks: templateSchedule.getBlocks())
					schedule = dateSchedule
				} else {
					self.out("Couldn't find a suitable schedule for date: \(offsetDate.webSafeDate)")
					continue
				}
				
				for block in schedule.getBlocks() {
					if selfItem.isCancelled {
						return
					}

					let analyst = BlockAnalyst(schedule: schedule, block: block)
					var toSchedule: [(KLNotification, UNNotificationRequest)] = []

					if analyst.shouldShowBeforeClassNotifications() {
						if let beforeClassNotificationRequest = self.buildBeforeClassNotification(date: offsetDate, block: block, analyst: analyst, schedule: schedule) {
							toSchedule.append(beforeClassNotificationRequest)
						}
					}
					
					if analyst.shouldShowAfterClassNotifications() {
						if let afterClassNotificationRequest = self.buildAfterClassNotification(date: offsetDate, block: block, analyst: analyst, schedule: schedule) {
							toSchedule.append(afterClassNotificationRequest)
						}
					}
					
					for notification in toSchedule {
						let klnotification = notification.0
						let request = notification.1
					
						if !self.validateNotificationCount() { // Ensure that we have space to do this
							selfItem.cancel()
							return
						}
						
						let group = DispatchGroup()
						group.enter()
						
						self.hub.add(request) {
							error in
							
							if error != nil {
								self.out("Failed to add notification: \(error!.localizedDescription)")
							} else {
								if selfItem.isCancelled { // If the item is cancelled by the time the hub registers this, we have no real choice but to remove it immediately. I doubt this will hurt the hub at all but don't quote me on that.
									self.hub.removePendingNotificationRequests(withIdentifiers: [klnotification.id])
								} else {
									self.saveNotification(notification: klnotification)
								}
							}
							
							group.leave()
						}
						
						group.wait()
					}
				}
			}
		}
		
		self.currentDispatchItem = dispatchItem
		self.dispatchQueue.async(execute: dispatchItem)
		self.dispatchQueue.async {
			if self.currentDispatchItem === dispatchItem { // Only save if the current item is still active and it hasn't been replaced.
				self.saveStorage()
			}
			
			self.out("Finished registering notifications. \(self.scheduledNotifications.count) registered.")
			
			if let queue = queue {
				queue.leave() // Notify the notification handler that we're done.
			}
		}
	}
	
	private func buildBeforeClassNotification(date: Date, block: Block, analyst: BlockAnalyst, schedule: Schedule) -> (KLNotification, UNNotificationRequest)? {
		guard let time = Date.mergeDateAndTime(date: date, time: block.time.start) else {
			self.out("Failed to find start time for block: \(block)")
			return nil
		}
		
		guard let adjustedTime = Calendar.normalizedCalendar.date(byAdding: .minute, value: -5, to: time) else {
			self.out("Failed to find adjusted start time for block: \(block)")
			return nil
		}
		
		if adjustedTime < Date.today { // If this was earlier today or has already passed.
			return nil
		}
		
		let klnotification = KLNotification(date: adjustedTime)
		
		let content = UNMutableNotificationContent()
		
		if analyst.getCourse() == nil {
			content.title = "Next Block"
		} else {
			content.title = "Get to Class"
		}
		
		content.sound = UNNotificationSound.default()
		content.body = "5 min until \(analyst.getDisplayName())"
		
		content.threadIdentifier = "schedule"
		
		if analyst.getLocation() != nil {
			content.body = content.body + ". \(analyst.getLocation()!)"
		}
		
		let trigger = self.buildTrigger(date: adjustedTime)
		
		let request = UNNotificationRequest(identifier: klnotification.id, content: content, trigger: trigger)
		return (klnotification, request)
	}
	
	private func buildAfterClassNotification(date: Date, block: Block, analyst: BlockAnalyst, schedule: Schedule) -> (KLNotification, UNNotificationRequest)? {
		guard let time = Date.mergeDateAndTime(date: date, time: block.time.end) else {
			self.out("Failed to find start time for block: \(block)")
			return nil
		}
		
		guard let adjustedTime = Calendar.normalizedCalendar.date(byAdding: .minute, value: -2, to: time) else {
			self.out("Failed to find adjusted start time for block: \(block)")
			return nil
		}
		
		if adjustedTime < Date.today { // If this was earlier today or has already passed.
			return nil
		}
		
		let klnotification = KLNotification(date: adjustedTime)
		
		let content = UNMutableNotificationContent()
		
		if analyst.getCourse() == nil {
			content.title = "End of Block"
		} else {
			content.title = "End of Class"
		}
		
		content.sound = UNNotificationSound.default()
		content.body = "\(analyst.getDisplayName()) ends in 2 min"
		
		content.threadIdentifier = "schedule"
		
		let trigger = self.buildTrigger(date: adjustedTime)
		
		let request = UNNotificationRequest(identifier: klnotification.id, content: content, trigger: trigger)
		return (klnotification, request)
	}
	
	private func buildTrigger(date: Date) -> UNCalendarNotificationTrigger {
		return UNCalendarNotificationTrigger(dateMatching: Calendar.normalizedCalendar.dateComponents([.year, .month, .day, .hour, .minute, .calendar, .timeZone], from: date), repeats: false)
	}
	
	func doListenerRefresh(date: Date, queue: DispatchGroup) {
		queue.enter()
		
		self.fetchSpecialSchedules(queue: queue)
	}
	
	func fetchSpecialSchedules(queue: DispatchGroup? = nil) {
		self.specialSchedules = nil
		self.specialSchedulesError = nil
		
		SpecialSchedulesWebCall(date: Date.today).callback() {
			result in
			
			switch result {
			case .success(let payload):
				self.specialSchedules = payload
				self.specialSchedulesError = nil
			case .failure(let error):
				self.specialSchedules = nil
				self.specialSchedulesError = error
			}
			
			self.finishedSpecialSchedulesFetch(queue: queue)
		}.execute()
	}
	
	func finishedSpecialSchedulesFetch(queue: DispatchGroup? = nil) {
		self.scheduleNotifications(daysAhead: self.projection, queue: queue)
	}
	
}

