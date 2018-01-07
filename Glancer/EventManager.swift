//
//  EventManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class EventManager: Manager
{
	static let instance = EventManager()
	
	var events: [EnscribedDate: FetchContainer<EventList>]
	
	init()
	{
		self.events = [:]
		
		super.init(name: "Event Manager")
	}
	
	func getEvents(_ date: EnscribedDate) -> RemoteResource<EventList>
	{
		let status = self.events[date] == nil ? .dead : self.events[date]!.status
		if status == .loaded, let eventList = self.events[date]?.data
		{
			return RemoteResource(status, eventList)
		}
		return RemoteResource(status, nil)
	}
	
	@discardableResult
	func fetchEvents(_ date: EnscribedDate, _ callback: @escaping (ResourceFetch<EventList>) -> Void = {_ in}) -> ResourceFetchToken
	{
		let token = ResourceFetchToken()
		self.events[date] = FetchContainer(token)
		
		let call = GetEventsWebCall(self, date: date, token: token)
		call.addCallback(
		{ fetch in
			if self.events[date] != nil
			{
				self.events[date]!.setResult(fetch)
			}
			callback(fetch)
		})
		call.execute()
		return token
	}
}
