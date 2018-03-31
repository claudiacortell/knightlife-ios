//
//  CourseSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

enum CourseFrequency
{
    case
    everyDay,
    specificDays
}

class CourseSchedule
{
    var block: BlockID //Null = all day
	var frequency: CourseFrequency
	
    var meetingDays: [DayID]? // Only used for specific day meetings

	init(block: BlockID, frequency: CourseFrequency)
	{
		self.block = block
		self.frequency = frequency
	}
}
