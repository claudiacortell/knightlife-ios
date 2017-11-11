//
//  CourseActivity.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct CourseActivity: Activity
{
	var type: ActivityType = .course
	
	var name: String
	
	var meetingSchedule: MeetingSchedule?
	
    var room: String? // Room #
    var teacher: String? // Teacher name.
}
