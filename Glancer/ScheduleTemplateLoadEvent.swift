//
//  ScheduleTemplateLoadEvent.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/23/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class ScheduleTemplateLoadEvent: Event
{
	let successful: Bool
	
	init(successful: Bool)
	{
		self.successful = successful
		
		super.init(name: "schedule.template.load")
	}
}
