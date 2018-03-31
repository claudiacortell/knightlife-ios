//
//  Course.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class Course
{
	var name: String // Course name
	var courseSchedule: CourseSchedule?
	
	var color: String?
	var location: String?
	
	init(name: String, schedule: CourseSchedule? = nil)
	{
		self.name = name
		self.courseSchedule = schedule
	}
}
