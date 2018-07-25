//
//  BlockCourseList.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/28/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct BlockCourseList {
	
	let block: BlockID
	let courses: [Course]
	
}

extension BlockCourseList {
	
	var isEmpty: Bool {
		return self.courses.isEmpty
	}
	
}
