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
						if let meta = UserPrefsManager.instance.getMeta(id: block.blockId)
						{
							self.updateNotifications(day: dayId, block: block, meta: meta)
						}
					}
				}
			}
		}
	}
	
	func prefsDidUpdate()
	{
		self.clearNotifications()
		for dayId in DayID.values()
		{
			if let blocks = ScheduleManager.instance.blockList(id: dayId)
			{
				for block in blocks
				{
					if let meta = UserPrefsManager.instance.getMeta(id: block.blockId)
					{
						self.updateNotifications(day: dayId, block: block, meta: meta)
					}
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
	
	func updateNotifications(day: DayID, block: Block, meta: UserPrefsManager.BlockMeta)
	{
		let blockName: String! = block.hasOverridenDisplayName ? block.overrideDisplayName : meta.customName
		if (!ScheduleManager.instance.onVacation) // only perform notifications if we aren't on vacation
		{
			let notification: UILocalNotification = UILocalNotification()
			var scheduledDate = block.startTime.asDate()
			
			notification.alertAction = "Knight Life"
			
			notification.repeatInterval = NSCalendar.Unit.weekOfYear
			notification.soundName = UILocalNotificationDefaultSoundName;
			
			let today = TimeUtils.getDayOfWeekFromString(TimeUtils.currentDateAsString()) // 0 to 6 for Monday - Sunday
			let dayMult = day
			
			// TODO: Fix notifications
			
//			if (block.isLunchBlock)
//			{
//				notification.alertBody = blockName
//				
//				scheduledDate = day.secondLunchStart != nil ? day.secondLunchStart!.asDate() : scheduledDate
//				scheduledDate = scheduledDate.addingTimeInterval(60 * 60 * 24 * dayMultiplier)
//			} else
//			{
//				notification.alertBody = "5 minutes until " + blockName;
//
//				scheduledDate = scheduledDate.addingTimeInterval(-60*5) // call 5 minutes before the class starts
//				scheduledDate = scheduledDate.addingTimeInterval(60 * 60 * 24 * dayMultiplier) // Register for the previous week so it for sure works this week
//			}
//
//			notification.fireDate = scheduledDate
//			UIApplication.shared.scheduleLocalNotification(notification)
		}
	}
}
