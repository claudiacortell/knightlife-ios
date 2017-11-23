//
//  SchedulePatchAttemptLoadEvent.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/23/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class SchedulePatchAttemptLoadEvent: Event
{
	let date: EnscribedDate
	
	init(date: EnscribedDate)
	{
		self.date = date
		
		super.init(name: "schedule.patch.attemptload")
	}
}
