//
//  NotificationsManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/14/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class NotificationsManager
{
	static let instance = NotificationsManager()
	
	init()
	{
		
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
	
	func updateNotifications(day: Weekday, block: Block, meta: UserPrefsManager.BlockMeta)
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
			let dayMult = day.dayId.id
			
			if (block.isLunchBlock)
			{
				notification.alertBody = blockName
				
				scheduledDate = day.secondLunchStart != nil ? day.secondLunchStart!.asDate() : scheduledDate
				scheduledDate = scheduledDate.addingTimeInterval(60 * 60 * 24 * dayMultiplier)
			} else
			{
				notification.alertBody = "5 minutes until " + blockName;

				scheduledDate = scheduledDate.addingTimeInterval(-60*5) // call 5 minutes before the class starts
				scheduledDate = scheduledDate.addingTimeInterval(60 * 60 * 24 * dayMultiplier) // Register for the previous week so it for sure works this week
			}

			notification.fireDate = scheduledDate
			UIApplication.shared.scheduleLocalNotification(notification)
		}
	}
}
