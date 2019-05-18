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
import SwiftyJSON
import Moya

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

class NotificationManager: AddictiveLib.Manager, PushRefreshListener {
	
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
	private(set) var weekSchedules: [Schedule]?
	private(set) var weekSchedulesError: Error?
	
	var weekSchedulesLoaded: Bool {
		return self.weekSchedules != nil || self.weekSchedulesError != nil
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
		
		// Reschedule notifications on First Lunch change
		Schedule.onFirstLunchChange.subscribe(with: self) { change in
			self.scheduleShallowNotifications()
		}
		
		TodayM.onNextDay.subscribe(with: self) { date in
			self.hub.removeAllDeliveredNotifications()
			self.scheduleNotifications(daysAhead: self.projection)
		}
		
		TodayM.fetchTodayBundle()
		
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
		
		if !self.weekSchedulesLoaded {
			self.out("Couldn't schedule notifications: Special Schedules not downloaded.")
			return
		}
		
		guard let specialSchedules = self.weekSchedules else {
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
				} else {
					self.out("Couldn't find a suitable schedule for date: \(offsetDate.webSafeDate)")
					continue
				}
				
				for block in (schedule.selectedTimetable?.filterBlocksByLunch() ?? []) {
					if selfItem.isCancelled {
						return
					}

					let analyst = block.analyst
					var toSchedule: [(KLNotification, UNNotificationRequest)] = []

					if analyst.shouldShowBeforeClassNotifications {
						if let beforeClassNotificationRequest = self.buildBeforeClassNotification(date: offsetDate, block: block, analyst: analyst, schedule: schedule) {
							toSchedule.append(beforeClassNotificationRequest)
						}
					}
					
					if analyst.shouldShowAfterClassNotifications {
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
	
	private func buildBeforeClassNotification(date: Date, block: Block, analyst: Block.Analyst, schedule: Schedule) -> (KLNotification, UNNotificationRequest)? {
		guard let time = Date.mergeDateAndTime(date: date, time: block.schedule.start) else {
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
		
		if analyst.bestCourse == nil {
			content.title = "Next Block"
		} else {
			content.title = "Get to Class"
		}
		
		content.sound = UNNotificationSound.default()
		content.body = "5 min until \(analyst.displayName)"
		
		content.threadIdentifier = "schedule"
		
		if analyst.location != nil {
			content.body = content.body + ". \(analyst.location!)"
		}
		
		let trigger = self.buildTrigger(date: adjustedTime)
		
		let request = UNNotificationRequest(identifier: klnotification.id, content: content, trigger: trigger)
		return (klnotification, request)
	}
	
	private func buildAfterClassNotification(date: Date, block: Block, analyst: Block.Analyst, schedule: Schedule) -> (KLNotification, UNNotificationRequest)? {
		guard let time = Date.mergeDateAndTime(date: date, time: block.schedule.end) else {
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
		
		if analyst.bestCourse == nil {
			content.title = "End of Block"
		} else {
			content.title = "End of Class"
		}
		
		content.sound = UNNotificationSound.default()
		content.body = "\(analyst.displayName) ends in 2 min"
		
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
		self.weekSchedules = nil
		self.weekSchedulesError = nil
		
		let provider = MoyaProvider<API>()
		provider.request(.getWeekBundles) {
			switch $0 {
			case .success(let res):
				do {
					_ = try res.filterSuccessfulStatusCodes()

					let data = res.data
					let json = try JSON(data: data)
					
					let bundles = try json.dictionaryValue.values.compactMap({ try Day(json: $0) })
					
					// Because we don't registeer notifications for Events yet, we're just taking the bundle then getting the schedules out
					let schedules = bundles.map({ $0.schedule! })
					
					self.weekSchedules = schedules
					self.weekSchedulesError = nil
				} catch {
					self.weekSchedules = nil
					self.weekSchedulesError = error
					
					print(error)
				}
			case .failure(let error):
				self.weekSchedules = nil
				self.weekSchedulesError = error
				
				print(error)
			}

			self.finishedSpecialSchedulesFetch(queue: queue)
		}
	}
	
	func finishedSpecialSchedulesFetch(queue: DispatchGroup? = nil) {
		self.scheduleNotifications(daysAhead: self.projection, queue: queue)
	}
	
}

