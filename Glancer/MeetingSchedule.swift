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
    specificDays
}

struct MeetingSchedule
{
    var frequency: MeetingFrequency
    var block: BlockID
    var meetingDays: [DayID]
}
