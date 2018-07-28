//
//  EventAudience.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct EventAudience {
	
	let grade: Grade
	let mandatory: Bool
	
}

enum Grade: Int {
	
	case allSchool

	case freshmen
	case sophomores
	case juniors
	case seniors
	
}
