//
//  EventList.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

struct EventList
{
	let date: EnscribedDate
	let events: [Event]
	
	init(_ date: EnscribedDate, events: [Event])
	{
		self.date = date
		self.events = events
	}
}
