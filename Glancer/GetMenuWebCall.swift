//
//  GetMenuWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class GetMenuWebCall: WebCall<GetMenuResponse, LunchMenu>
{
	let manager: LunchManager
	let date: EnscribedDate
	
	init(_ manager: LunchManager, date: EnscribedDate)
	{
		self.manager = manager
		self.date = date
		
		super.init(call: "request/lunch")
		
		self.parameter("dt", val: date.string)
	}
	
	override func handleTokenConversion(_ data: GetMenuResponse) -> LunchMenu?
	{
		var items: [LunchMenuItem] = []
		for item in data.items
		{
			if let type = LunchMenuItemType.fromString(item.type)
			{
				let item = LunchMenuItem(type, name: item.name, allergy: item.allergy)
				items.append(item)
			}
		}
		
		return LunchMenu(self.date, title: data.caption, items: items)
	}
	
	override func handleCall(error: FetchError?, data: LunchMenu?)
	{
		
	}
}
