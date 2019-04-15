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
			var audience: [EventAudience] = []
			for group in event.audience {
				guard let grade = Grade(rawValue: group.id) else {
					print("Invalid grade supplied: \(group.id)")
					continue
				}
				
				audience.append(EventAudience(grade: grade, mandatory: group.mandatory))
			}
			
			if let rawBlock = event.block, let blockId = Block.ID(rawValue: rawBlock) {
				events.append(BlockEvent(block: blockId, description: event.description, audience: audience))
			} else if let rawTime = event.time, let startTime = Date.fromWebTime(string: rawTime.start) {
				guard let start = Date.mergeDateAndTime(date: self.date, time: startTime) else {
					print("Couldn't parse event start/end times.")
					continue
				}
				
				let end: Date? = {
					guard let rawEnd = rawTime.end, let endTime = Date.fromWebTime(string: rawEnd) else {
						return nil
					}
					
					guard let end = Date.mergeDateAndTime(date: self.date, time: endTime) else {
						return nil
					}
					
					return end
				}()
				
				events.append(TimeEvent(startTime: start, endTime: end, description: event.description, audience: audience))
			} else {
				print("Couldn't parse event block: \(event.block ?? "-")")
			}
		}
		return EventList(date: self.date, events: events)
	}
}

class EventPayload: WebCallPayload {
	
	let description: String
	let audience: [EventAudiencePayload]
	
	let block: String?
	let time: EventTimePayload?
	
	required init(unboxer: Unboxer) throws {
		self.description = try unboxer.unbox(key: "description")
		self.audience = try unboxer.unbox(key: "audience")
		
		self.block = unboxer.unbox(key: "block")
		self.time = unboxer.unbox(key: "time")
	}
	
}

class EventTimePayload: WebCallPayload {
	
	let start: String
	let end: String?
	
	required init(unboxer: Unboxer) throws {
		self.start = try unboxer.unbox(keyPath: "start")
		self.end = unboxer.unbox(keyPath: "end")
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
