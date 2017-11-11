//
//  ActivityManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/25/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class ActivityManager: Manager
{
    static let instance = ActivityManager()
    
    var activities: [Activity]
    
    init()
    {
		self.activities = []
		
		super.init(name: "Activity Manager")
	}
	
	func getActivities(date: EnscribedDate = TimeUtils.todayEnscribed) -> ActivityList?
	{
		var list: [Activity] = []
		for activity in self.activities
		{
			if let schedule = activity.meetingSchedule
			{
				switch schedule.frequency
				{
				case .everyDay:
					if let blocks = ScheduleManager.instance.retrieveBlockList(date: date)
					{
						if blocks.hasBlock(id: schedule.block)
						{
							list.append(activity)
						}
					}
					break
				case .specificDays:
					if let day = TimeUtils.getDayOfWeek(date)
					{
						if schedule.meetingDays.contains(day)
						{
							if let blocks = ScheduleManager.instance.retrieveBlockList(date: date)
							{
								if blocks.hasBlock(id: schedule.block)
								{
									list.append(activity)
								}
							}
						}
					}
					break
				case .oneTime:
					if schedule.meetingDate == date
					{
						list.append(activity)
					}
					break
				}
			}
		}
		
		return ActivityList(activities: list)
	}
}
