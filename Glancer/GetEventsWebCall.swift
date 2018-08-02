//
//  GetEventsWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class GetEventsWebCall: UnboxWebCall<KnightlifeListPayload<EventPayload>, EventList> {
	
	let date: Date
	
	init(date: Date) {
		self.date = date
		
		super.init(call: "events")
		
		self.parameter("date", val: date.webSafeDate)
	}
	
	override func convertToken(_ data: KnightlifeListPayload<EventPayload>) -> EventList? {
		guard let content = data.content else {
			return nil
		}
		
		var events: [Event] = []
		for event in content {
			guard let blockId = BlockID.fromStringValue(name: event.block) else {
				print("Wasn't able to parse event block: \(event.block)")
				continue
			}
			
			var audience: [EventAudience] = []
			for group in event.audience {
				guard let grade = Grade(rawValue: group.id) else {
					print("Invalid grade supplied: \(group.id)")
					continue
				}
				
				audience.append(EventAudience(grade: grade, mandatory: group.mandatory))
			}
			
			events.append(Event(block: blockId, description: event.description, audience: audience))
		}
		return EventList(date: self.date, events: events)
	}
}

class EventPayload: WebCallPayload {
	
	let block: String
	let description: String

	let audience: [EventAudiencePayload]
	
	required init(unboxer: Unboxer) throws {
		self.block = try unboxer.unbox(key: "block")
		self.description = try unboxer.unbox(key: "description")

		self.audience = try unboxer.unbox(key: "audience")
	}
	
}

class EventAudiencePayload: WebCallPayload {
	
	let id: Int
	let mandatory: Bool
	
	required init(unboxer: Unboxer) throws {
		self.id = try unboxer.unbox(key: "grade")
		self.mandatory = try unboxer.unbox(key: "mandatory")
	}
	
}
