//
//  MeetingManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/25/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class MeetingManager: Manager
{
    static let instance = MeetingManager()
    
	private(set) var meetings: [String: Meeting] // All added meetings including one time ones.
    
    init()
    {
		self.meetings = [:]
		super.init(name: "Meetings Manager")
		
		self.registerModule(MeetingPrefModule(self, name: "meetings"))
	}
	
	func addMeeting(_ meeting: Meeting)
	{
		self.meetings[meeting.id] = meeting
	}
	
	func getMeeting(id: String) -> Meeting?
	{
		return self.meetings[id]
	}
	
	func getMeetings(type: MeetingType) -> MeetingList
	{
		var list = MeetingList()
		for meeting in self.meetings.values
		{
			if meeting.type == type
			{
				list.meetings.append(meeting)
			}
		}
		return list
	}
	
	func getMeetings(date: EnscribedDate, schedule: DaySchedule, block: BlockID) -> BlockMeetingList
	{
		return self.getMeetings(date: date, schedule: schedule).fromBlock(block)
	}
	
	func getMeetings(date: EnscribedDate, schedule: DaySchedule) -> DayMeetingList // You have to supply your own schedule. I don't wanna have to deal with calling it and dealing with the web call
	{
		var list = DayMeetingList()
		list.date = date
		
		for activity in self.meetings.values
		{
			if self.doesMeetOnDate(activity, date: date, schedule: schedule)
			{
				list.meetings.append(activity)
			}
		}
		
		return list
	}
	
	func doesMeetOnDate(_ meeting: Meeting, date: EnscribedDate, schedule: DaySchedule) -> Bool
	{
		if let meetingSchedule = meeting.meetingSchedule
		{
			switch meetingSchedule.frequency
			{
			case .everyDay:
				if meetingSchedule.block == nil || schedule.hasBlock(id: meetingSchedule.block!)
				{
					return true
				}
				break
			case .specificDays:
				if let dayId = date.dayOfWeek
				{
					if meetingSchedule.meetingDays.contains(dayId)
					{
						if meetingSchedule.block == nil || schedule.hasBlock(id: meetingSchedule.block!)
						{
							return true
						}
					}
				}
				break
			case .oneTime:
				if meetingSchedule.meetingDate == date
				{
					if meetingSchedule.block == nil || schedule.hasBlock(id: meetingSchedule.block!)
					{
						return true
					}
				}
				break
			}
		}
		return false
	}
}
