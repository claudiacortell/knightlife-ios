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

class GetEventsWebCall: UnboxWebCall<GetEventsResponse, EventList> {
	
	let date: Date
	
	init(date: Date) {
		self.date = date
		
		super.init(call: "request/events")
		
		self.parameter("date", val: date.webSafeDate)
	}
	
	override func convertToken(_ data: GetEventsResponse) -> EventList? {
		var events: [Event] = []
		for event in data.events {
			if let blockId = BlockID.fromStringValue(name: event.blockId) {
				var audience: [EventAudience] = []
				for group in event.audience {
					if let val = EventAudience(rawValue: group) {
						audience.append(val)
					}
				}
				
				let item = Event(blockId: blockId, mandatory: event.mandatory, audience: audience, description: event.description)
				events.append(item)
			}
		}
		return EventList(date: self.date, events: events)
	}
}

class GetEventsResponse: WebCallPayload {
	
	let events: [GetEventsResponseEvent]
	
	required init(unboxer: Unboxer) throws {
		self.events = try unboxer.unbox(keyPath: "events", allowInvalidElements: false)
	}
	
}

class GetEventsResponseEvent: WebCallPayload {
	
	let blockId: String
	let mandatory: Bool
	let audience: [Int]
	
	let description: String
	
	required init(unboxer: Unboxer) throws {
		self.blockId = try unboxer.unbox(key: "blockId")
		self.mandatory = try unboxer.unbox(key: "mandatory")
		self.audience = try unboxer.unbox(key: "audience")
		
		self.description = try unboxer.unbox(key: "description")
	}
	
}
