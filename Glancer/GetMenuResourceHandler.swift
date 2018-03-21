//
//  GetMenuResourceHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/15/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class GetMenuResourceHandler: ResourceHandler<(EnscribedDate, LunchMenu?)>
{
	private var manager: LunchManager
	var menus: [EnscribedDate: LunchMenu] = [:]
	
	init(_ manager: LunchManager)
	{
		self.manager = manager
	}
	
	@discardableResult
	func getMenu(_ date: EnscribedDate, hard: Bool = false, callback: @escaping (FetchError?, LunchMenu?) -> Void = {_,_ in}) -> LunchMenu?
	{
		if hard || self.menus[date] == nil // Requires reload
		{
			let call = GetMenuWebCall(manager, date: date)
			call.callback =
			{ error, result in
				callback(error, result)

				if let success = result
				{
					self.menus[date] = success
					self.success((date, success))
				} else if error == nil
				{
					self.menus[date] = nil
					self.success((date, nil))
				} else
				{
					self.menus[date] = nil
					self.failure(error!)
				}
			}
			call.execute()
			return nil
		} else
		{
			return menus[date]
		}
	}
}
