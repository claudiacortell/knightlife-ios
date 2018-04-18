//
//  DayMeetingList.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/10/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

struct DayCourseList
{
	var date: EnscribedDate
	var meetings: [Course]
	
	init(_ date: EnscribedDate, _ courses: [Course])
	{
		self.date = date
		self.meetings = courses
	}
}

extension DayCourseList
{
	func fromBlock(_ block: BlockID) -> BlockCourseList
	{
		var list: [Course] = []
		
		for activity in self.meetings
		{
			if activity.courseSchedule.block == block
			{
				list.append(activity)
			}
		}
		return BlockCourseList(block, list)
	}
}
