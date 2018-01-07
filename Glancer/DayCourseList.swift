//
//  DayMeetingList.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/10/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct DayCourseList
{
	var date: EnscribedDate!
	var meetings: [Course] = []
}

extension DayCourseList
{
	func fromBlock(_ block: BlockID) -> BlockCourseList
	{
		var list = BlockCourseList()
		list.block = block
		
		for activity in self.meetings
		{
			if activity.courseSchedule != nil
			{
				if activity.courseSchedule!.block == block
				{
					list.courses.append(activity)
				}
			}
		}
		return list
	}
	
	func fromId(_ id: Int) -> Course?
	{
		for meeting in self.meetings
		{
			if meeting.hashValue == id
			{
				return meeting
			}
		}
		return nil
	}
}
