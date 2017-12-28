//
//  GetEventsWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class GetEventsWebCall: WebCall<EventManager, GetEventsResponse, EventList>
{
	let date: EnscribedDate
	
	init(_ manager: EventManager, date: EnscribedDate, token: ResourceFetchToken)
	{
		self.date = date
		
		super.init(manager: manager, converter: GetEventsConverter(), token: token, call: "request/events.php")
		
		self.parameter("date", val: date.toString())
	}
}
