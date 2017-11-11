//
//  MeetingSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

enum MeetingFrequency
{
    case
    everyDay,
    specificDays,
	oneTime
}

struct MeetingSchedule
{
    var block: BlockID
	var frequency: MeetingFrequency
	
    var meetingDays: [DayID] // Only used for specific day meetings
	var meetingDate: EnscribedDate // Only used for oneTime meetings.
}
