//
//  ClassMeeting.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class ClassMeeting: Meeting
{
    var room: String? // Room #
    var teacher: String? // Teacher name.
	
	init(_ name: String, schedule: MeetingSchedule? = nil, room: String? = nil, teacher: String? = nil)
	{
		super.init(.course, name: name, schedule: schedule)
	}
}
