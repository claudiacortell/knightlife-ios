//
//  GetEventsConverter.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class GetEventsConverter: WebCallResultConverter<EventManager, GetEventsResponse, EventList>
{
	override func convert(_ data: GetEventsResponse) -> EventList?
	{
		var list = EventList()
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
				list.events.append(item)
			}
		}
		return list
	}
}
