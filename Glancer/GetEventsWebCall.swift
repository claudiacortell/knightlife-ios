//
//  GetEventsWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class GetEventsWebCall: UnboxWebCall<GetEventsResponse, EventList>
{
	let manager: EventManager
	let date: EnscribedDate
	
	init(_ manager: EventManager, date: EnscribedDate)
	{
		self.manager = manager
		self.date = date
		
		super.init(call: "request/events")
		
		self.parameter("date", val: date.string)
	}
	
	override func convertToken(_ data: GetEventsResponse) -> EventList?
	{
		var events: [Event] = []
		for event in data.events
		{
			if let blockId = BlockID.fromRaw(raw: event.blockId)
			{
				var audience: [EventAudience] = []
				for group in event.audience
				{
					if let val = EventAudience.fromId(group)
					{
						audience.append(val)
					}
				}
				
				let item = Event(blockId: blockId, mandatory: event.mandatory, audience: audience, name: event.name, description: event.description)
				events.append(item)
			}
		}
		return EventList(self.date, events: events)
	}
	
	override func handleCall(error: ResourceWatcherError?, data: EventList?)
	{
		
	}
}
