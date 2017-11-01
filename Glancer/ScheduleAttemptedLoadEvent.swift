//
//  ScheduleAttemptedLoadEvent.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/30/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class ScheduleAttemptedLoadEvent: Event
{
	let success: Bool
	
	init(success: Bool)
	{
		self.success = success
		super.init(name: "schedule.attempted.load")
	}
}
