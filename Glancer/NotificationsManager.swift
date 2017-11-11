//
//  NotificationsManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/14/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation
import UIKit

class NotificationsManager
//	: ScheduleUpdateHandler, PrefsUpdateHandler
{
//	static let instance = NotificationsManager()
//
//	init()
//	{
//		ScheduleManager.instance.addHandler(self)
//		UserPrefsManager.instance.addHandler(self)
//	}
//
//	func scheduleDidUpdate(didUpdateSuccessfully: Bool)
//	{
//		updateGlobalNotifications()
//	}
//
//	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
//	{
//		if type == .lunch
//		{
//			return // The schedule will update from lunch changes. So we'll deal with this there.
//		}
//
//		updateGlobalNotifications()
//	}
//
//	private func updateGlobalNotifications()
//	{
//		UIApplication.shared.cancelAllLocalNotifications()
//
//		Debug.out("Updating notifications")
//		if ScheduleManager.instance.onVacation
//		{
//			return
//		}
//
//		for dayId in DayID.values()
//		{
//			Debug.out("------------------\(dayId.rawValue)")
//			if let blocks = ScheduleManager.instance.blockList(id: dayId)
//			{
//				for block in blocks
//				{
//					self.updateNotifications(block: block)
//				}
//			}
//		}
//
//		Debug.out("Successfully updated notifications")
//	}
//
//	func updateNotifications(block: Block)
//	{
//		let analyst = block.analyst
//		var date: Date = analyst.getStartTime().asDate()
//
//		let blockStartDateId: Int = block.weekday.id
//		let todayId: Int = TimeUtils.getDayOfWeek(date: Date())
//
//		var dayMultiplier: Int = blockStartDateId - todayId
//		if dayMultiplier < 0 { dayMultiplier += 7 }
//		dayMultiplier -= 7 // Start schedule on the previous week
//
//		var alertBody = ""
//
//		if block.isLunchBlock
//		{
//			alertBody = analyst.getDisplayName()
//
//			date = date.addingTimeInterval(TimeInterval(60 * 60 * 24 * dayMultiplier))
//		} else
//		{
//			alertBody = "5 minutes until \(analyst.getDisplayName())"
//
//			date = date.addingTimeInterval(-60 * 5) // call 5 minutes before the class starts
//			date = date.addingTimeInterval(TimeInterval(60 * 60 * 24 * dayMultiplier)) // Register for the previous week so it for sure works this week
//		}
//
//		let dateFormatter = DateFormatter()
//		dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//
//		Debug.out("Adding notification with alert: '\(alertBody)' on date: \(dateFormatter.string(from: date))")
//		self.scheduleNotification(text: alertBody, fireDate: date)
//	}
//
//	private func scheduleNotification(text: String, fireDate: Date)
//	{
//		let notification: UILocalNotification = UILocalNotification()
//		notification.alertAction = "Knight Life"
//		notification.repeatInterval = NSCalendar.Unit.weekOfYear
//		notification.soundName = UILocalNotificationDefaultSoundName
//		notification.alertBody = text
//		notification.fireDate = fireDate
//		UIApplication.shared.scheduleLocalNotification(notification)
//	}
}
