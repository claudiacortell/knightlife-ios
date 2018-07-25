//
//  Course.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

class Course {
	
	var name: String // Course name
	var courseSchedule: CourseSchedule
	
	var color: UIColor?
	var location: String?
	
	init(name: String, schedule: CourseSchedule) {
		self.name = name
		self.courseSchedule = schedule
	}
	
}

extension Course: Equatable {
	
	static func ==(lhs: Course, rhs: Course) -> Bool {
		return lhs === rhs
	}
	
}
