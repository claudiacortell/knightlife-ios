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
	
	func getMenu(_ date: EnscribedDate, forceRefresh: Bool, allowRemoteFetch: Bool, success: @escaping ((remote: Bool, menu: LunchMenu)) -> Void, failure: @escaping (FetchError) -> Void)
	{
		if (forceRefresh || self.lunchMenus[date] == nil || !self.lunchMenus[date]!.hasData) && allowRemoteFetch
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

				if fetch.hasData
				{
					success((remote: true, menu: fetch.data!))
				} else
				{
					failure(.callError)
				}
			})
			call.execute()
		} else if let container = self.lunchMenus[date], container.hasData
		{
			success((remote: false, menu: container.data!))
		} else
		{
			failure(.refreshRestricted)
		}
	}
}
