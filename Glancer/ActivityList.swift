//
//  ActivityList.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/10/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct ActivityList
{
	var activities: [Activity]
}

extension ActivityList
{
	func getClass() -> CourseActivity?
	{
		for activity in self.activities
		{
			if activity.type == .course && activity is CourseActivity
			{
				return activity as? CourseActivity
			}
		}
		return nil
	}
	
	func hasClass() -> Bool
	{
		return self.getClass() != nil
	}
	
	func fromBlock(block: BlockID) -> [Activity]
	{
		var list: [Activity] = []
		for activity in self.activities
		{
			if activity.meetingSchedule != nil
			{
				if activity.meetingSchedule!.block == block
				{
					list.append(activity)
				}
			}
		}
		return list
	}
}
