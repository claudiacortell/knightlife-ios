//
//  EventAudience.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class EventAudience {
	
	let grade: Grade?
	let mandatory: Bool
	
	init(grade: Grade?, mandatory: Bool) {
		self.grade = grade
		self.mandatory = mandatory
	}
	
}
