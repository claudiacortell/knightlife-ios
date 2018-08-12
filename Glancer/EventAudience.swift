//
//  EventAudience.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class EventAudience {
	
	let grade: Grade
	let mandatory: Bool
	
	init(grade: Grade, mandatory: Bool) {
		self.grade = grade
		self.mandatory = mandatory
	}
	
}

enum Grade: Int {
	
	case allSchool

	case freshmen
	case sophomores
	case juniors
	case seniors
	
	var settingsDisplayName: String {
		switch self {
		case .allSchool:
			return "Not Set"
		case .freshmen:
			return "Freshman"
		case .sophomores:
			return "Sophomore"
		case .juniors:
			return "Junior"
		case .seniors:
			return "Senior"
		}
	}
	
	var displayName: String {
		switch self {
		case .allSchool:
			return "All School"
		case .freshmen:
			return "Freshmen"
		case .sophomores:
			return "Sophomores"
		case .juniors:
			return "Juniors"
		case .seniors:
			return "Seniors"
		}
	}
	
	static var values: [Grade] = [ .allSchool, .freshmen, .sophomores, .juniors, .seniors ]
	
}
