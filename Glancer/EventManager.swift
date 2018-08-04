//
//  EventManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class EventManager: Manager {
	
	static let instance = EventManager()

	private(set) var events: [String: EventList] = [:]
	private var eventWatchers: [String: ResourceWatcher<EventList>] = [:]
	
	init() {
		super.init("Events")
	}
	
	func getCachedEvents(date: Date) -> EventList? {
		return self.events[date.webSafeDate]
	}
	
	func getEventWatcher(date: Date) -> ResourceWatcher<EventList> {
		if self.eventWatchers[date.webSafeDate] == nil {
			self.eventWatchers[date.webSafeDate] = ResourceWatcher<EventList>()
		}
		return self.eventWatchers[date.webSafeDate]!
	}
	
	func getEvents(date: Date, force: Bool = false, then: @escaping (WebCallResult<EventList>) -> Void = {_ in}) {
		if !force, let events = self.getCachedEvents(date: date) {
			then(WebCallResult.success(result: events))
			return
		}
		
		GetEventsWebCall(date: date).callback() {
			result in
			
			var item: EventList?
			var fail: Error?
			
			switch result {
			case .success(let list):
				item = list
			case .failure(let error):
				fail = error
			}
			
			self.events[date.webSafeDate] = item
			self.getEventWatcher(date: date).handle(fail, item)
			
			then(result)
		}.execute()
	}
	
}
