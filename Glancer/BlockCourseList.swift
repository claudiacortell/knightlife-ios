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
	var block: BlockID
	var courses: [Course]
	
	init(_ block: BlockID, _ courses: [Course])
	{
		self.block = block
		self.courses = courses
	}
}

extension BlockCourseList
{
	var isEmpty: Bool
	{
		return self.courses.isEmpty
	}
}
