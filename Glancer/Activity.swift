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

protocol Activity
{
	var type: ActivityType { get }
	var name: String { get set } // Course name
    
	var meetingSchedule: MeetingSchedule? { get set }
}
