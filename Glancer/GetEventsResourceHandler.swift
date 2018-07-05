//
//  GetEventsResourceHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/15/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class GetEventsResourceHandler: ResourceWatcher<(EnscribedDate, EventList?)>
{
	private var manager: EventManager
	var menus: [EnscribedDate: EventList] = [:]
	
	init(_ manager: EventManager)
	{
		self.manager = manager
	}
	
	@discardableResult
	func getMenu(_ date: EnscribedDate, hard: Bool = false, callback: @escaping (ResourceWatcherError?, EventList?) -> Void = {_,_ in}) -> EventList?
	{
		if hard || self.menus[date] == nil // Requires reload
		{
			GetEventsWebCall(manager, date: date).callback() {
				error, result in
				
				if let success = result
				{
					self.menus[date] = success
					self.handle(nil, (date, success))
				} else if error == nil
				{
					self.menus[date] = nil
					self.handle(nil, (date, nil))
				} else
				{
					self.menus[date] = nil
					self.handle(error!, nil)
				}
			}.execute()
			return nil
		} else
		{
			return menus[date]
		}
	}
}
