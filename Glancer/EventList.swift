//
//  EventList.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

struct EventList {
	
	let date: Date
	let events: [Event]
	
}

extension EventList {
	
	func getEventsByBlock(block: BlockID) -> [Event] {
		var events: [Event] = []
		for event in self.events {
			if event.block == block {
				events.append(event)
			}
		}
		return events
	}
	
}
