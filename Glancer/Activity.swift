//
//  Activity.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

enum ActivityType
{
    case
    course, // Class E.G. English
    club, // Club or whatever E.G. Comp Sci Club
    other
}

class Activity
{
    let type: ActivityType
    var name: String // Course name
    
    var meetingSchedule: MeetingSchedule?
    
    init(type: ActivityType, name: String)
    {
        self.type = type
        self.name = name
    }
}
