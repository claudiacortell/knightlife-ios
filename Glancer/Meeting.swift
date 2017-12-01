//
//  Meeting.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

enum MeetingType
{
    case
    course, // Class E.G. English
    club, // Club or whatever E.G. Comp Sci Club
    other
}

class Meeting: Hashable
{
	var id: String = UUID().uuidString
	
	var type: MeetingType
	var name: String // Course name
    
	var meetingSchedule: MeetingSchedule?
	
	init(_ type: MeetingType, name: String, schedule: MeetingSchedule? = nil)
	{
		self.type = type
		self.name = name
		self.meetingSchedule = schedule
	}
}

extension Meeting
{
	var hashValue: Int
	{
		return self.id.hashValue
	}
	
	static func ==(lhs: Meeting, rhs: Meeting) -> Bool
	{
		return lhs.id == rhs.id // This should be adequate since the ID's should always be unique
	}
}
