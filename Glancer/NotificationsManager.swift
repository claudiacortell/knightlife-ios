//
//  NotificationsManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/14/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class NotificationsManager: ScheduleUpdateHandler, PrefsUpdateHandler
{
	static let instance = NotificationsManager()
	
	init()
	{
		ScheduleManager.instance.addHandler(self)
		UserPrefsManager.instance.addHandler(self)
	}
	
	func scheduleDidUpdate(didUpdateSuccessfully: Bool)
	{
		if didUpdateSuccessfully
		{
			self.clearNotifications()
			for dayId in DayID.values()
			{
				if let blocks = ScheduleManager.instance.blockList(id: dayId)
				{
					for block in blocks
					{
						self.updateNotifications(block: block)
					}
				}
			}
		}
	}
	
	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
	{
		self.clearNotifications()
		for dayId in DayID.values()
		{
			if let blocks = ScheduleManager.instance.blockList(id: dayId)
			{
				for block in blocks
				{
					self.updateNotifications(block: block)
				}
			}
		}
	}
	
	func clearNotifications()
	{
		let app:UIApplication = UIApplication.shared
		for Event in app.scheduledLocalNotifications!
		{
			let notification = Event
			app.cancelLocalNotification(notification)
		}
	}
	
	func updateNotifications(block: Block)
	{
		if !ScheduleManager.instance.onVacation
		{
			let notification: UILocalNotification = UILocalNotification()
			notification.alertAction = "Knight Life"
			notification.repeatInterval = NSCalendar.Unit.weekOfYear
			notification.soundName = UILocalNotificationDefaultSoundName;

			let analyst = block.analyst
			var date: Date = analyst.getStartTime().asDate()
			
			let blockStartDateId: Int = TimeUtils.getDayOfWeek(date: date)
			let todayId: Int = TimeUtils.getDayOfWeek(date: Date())
			
			var dayMultiplier: Int = blockStartDateId - todayId
			if dayMultiplier < 0 { dayMultiplier += 7 }
			
			if block.isLunchBlock
			{
				notification.alertBody = analyst.getDisplayName(true)
				
				date = date.addingTimeInterval(TimeInterval(60 * 60 * 24 * dayMultiplier))
			} else
			{
				notification.alertBody = "5 minutes until \(analyst.getDisplayName(true))"
				
				date = date.addingTimeInterval(-60 * 5) // call 5 minutes before the class starts
				date = date.addingTimeInterval(TimeInterval(60 * 60 * 24 * dayMultiplier)) // Register for the previous week so it for sure works this week
			}
			
			notification.fireDate = date
			UIApplication.shared.scheduleLocalNotification(notification)
		}
	}
}
