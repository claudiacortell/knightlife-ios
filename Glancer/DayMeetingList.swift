//
//  DayMeetingList.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/10/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct DayMeetingList
{
	var date: EnscribedDate!
	var meetings: [Meeting] = []
}

extension DayMeetingList
{
	func getClasses() -> [ClassMeeting]
	{
		var list: [ClassMeeting] = []
		for activity in self.meetings
		{
			if activity.type == .course && activity is ClassMeeting
			{
				list.append(activity as! ClassMeeting)
			}
		}
		return list
	}
	
	func fromBlock(_ block: BlockID) -> BlockMeetingList
	{
		var list = BlockMeetingList()
		list.block = block
		
		for activity in self.meetings
		{
			if activity.meetingSchedule != nil
			{
				if activity.meetingSchedule!.block == block
				{
					list.meetings.append(activity)
				}
			}
		}
		return list
	}
	
	func fromId(_ id: Int) -> Meeting?
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
