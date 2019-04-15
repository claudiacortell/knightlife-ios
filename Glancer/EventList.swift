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
	
	func getEventsByBlock(block: Block.ID) -> [BlockEvent] {
		return self.relevantEvents.filter({ $0 is BlockEvent }).map({ $0 as! BlockEvent }).filter({ $0.block == block })
	}
	
	func getOutOfSchoolEvents() -> [TimeEvent] {
		return self.relevantEvents.filter({ $0 is TimeEvent }).map({ $0 as! TimeEvent })
	}
	
	var hasOutOfSchoolEvents: Bool {
		return !self.getOutOfSchoolEvents().isEmpty
	}
	
	var relevantEvents: [Event] {
		return self.events.filter({ $0.isRelevantToUser() })
	}
	
}
