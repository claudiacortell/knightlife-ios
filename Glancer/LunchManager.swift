//
//  LunchManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class LunchManager: Manager
{
	static let instance = LunchManager()
	
	var lunchMenus: [EnscribedDate: FetchContainer<LunchMenu>]
	
	init()
	{
		self.lunchMenus = [:]
		
		super.init(name: "Lunch Manager")
	}
	
	func getMenu(_ date: EnscribedDate) -> LocalResource<LunchMenu>
	{
		let status = self.lunchMenus[date] == nil ? .dead : self.lunchMenus[date]!.status
		if status == .success, let menu = self.lunchMenus[date]?.data
		{
			return LocalResource(status, menu)
		}
		return LocalResource(status, nil)
	}
	
	@discardableResult
	func fetchMenu(_ date: EnscribedDate, _ callback: @escaping (ResourceFetch<LunchMenu>) -> Void = {_ in}) -> ResourceFetchToken
	{
		let token = ResourceFetchToken()
		self.lunchMenus[date] = FetchContainer(token)
		
		let call = GetMenuWebCall(self, date: date, token: token)
		call.addCallback(
			{ fetch in
				if self.lunchMenus[date] != nil
				{
					self.lunchMenus[date]!.setResult(fetch)
				}
				callback(fetch)
		})
		call.execute()
		return token
	}
}
