//
//  GetMenuConverter.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class GetMenuConverter: WebCallResultConverter<LunchManager, GetMenuResponse, LunchMenu>
{
	override func convert(_ data: GetMenuResponse) -> LunchMenu?
	{
		var menu = LunchMenu()
		for item in data.items
		{
			if let type = LunchMenuItemType.fromString(item.type)
			{
				let item = LunchMenuItem(type: type, name: item.name, allergy: item.allergy)
				menu.items.append(item)
			}
		}
		
		return menu
	}
}
