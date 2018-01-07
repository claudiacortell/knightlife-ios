//
//  BlockCourseList.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/28/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct BlockCourseList
{
	var block: BlockID!
	var courses: [Course] = []
}

extension BlockCourseList
{
	var isEmpty: Bool
	{
		return self.courses.isEmpty
	}
	
	func fromId(_ id: Int) -> Course?
	{
		for course in self.courses
		{
			if course.hashValue == id
			{
				return course
			}
		}
		return nil
	}
}
