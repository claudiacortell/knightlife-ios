//
//  GetMenuResourceHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/15/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class GetMenuResourceHandler: ResourceWatcher<(EnscribedDate, LunchMenu?)>
{
	private var manager: LunchManager
	var menus: [EnscribedDate: LunchMenu] = [:]
	
	init(_ manager: LunchManager)
	{
		self.manager = manager
		super.init()
	}
	
	@discardableResult
	func getMenu(_ date: EnscribedDate, hard: Bool = false, callback: @escaping (ResourceWatcherError?, LunchMenu?) -> Void = {_,_ in}) -> LunchMenu?
	{
		if hard || self.menus[date] == nil // Requires reload
		{
			GetMenuWebCall(manager, date: date).callback() {
				error, result in
				
				callback(error, result)

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
