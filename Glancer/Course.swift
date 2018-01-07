//
//  Course.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct Course: Hashable
{
	var id: String = UUID().uuidString
	
	var name: String // Course name
	var courseSchedule: CourseSchedule?
	
	var color: String?
	
	init(name: String, schedule: CourseSchedule? = nil)
	{
		self.name = name
		self.courseSchedule = schedule
	}
}

extension Course
{
	var hashValue: Int
	{
		return self.id.hashValue
	}
	
	static func ==(lhs: Course, rhs: Course) -> Bool
	{
		return lhs.id == rhs.id // This should be adequate since the ID's should always be unique
	}
}
