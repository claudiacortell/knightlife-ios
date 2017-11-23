//
//  SchedulePatchLoadEvent.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/23/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class SchedulePatchLoadEvent: Event
{
	let successful: Bool
	
	let date: EnscribedDate
	let patch: DaySchedule?
	
	init(successful: Bool, date: EnscribedDate, patch: DaySchedule?)
	{
		self.successful = successful
		
		self.date = date
		self.patch = patch
		
		super.init(name: "schedule.patch.load")
	}
}
