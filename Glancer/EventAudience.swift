//
//  EventAudience.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

enum EventAudience: String
{
	case
	
	freshman = "Freshmen",
	sophomore = "Sophomores",
	junior = "Juniors",
	senior = "Seniors",
	
	teachers = "Teachers",
	allSchool = "Everyone"
	
	static let values: [EventAudience] = [.freshman, .sophomore, .junior, .senior, .teachers, .allSchool]
	
	static func fromId(_ id: Int) -> EventAudience?
	{
		return EventAudience.values[id]
	}
}
