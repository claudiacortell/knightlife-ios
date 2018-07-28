//
//  GetMenuWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class GetMenuWebCall: UnboxWebCall<GetMenuResponse, LunchMenu> {
	
	let date: Date
	
	init(date: Date) {
		self.date = date
		
		super.init(call: "lunch")
		
		self.parameter("date", val: date.webSafeDate)
	}
	
	override func convertToken(_ data: GetMenuResponse) -> LunchMenu? {
		var items: [LunchMenuItem] = []
		
		for item in data.menu.items {
			if let type = LunchMenuItemType(rawValue: item.type) {
				let item = LunchMenuItem(type, name: item.name, allergy: item.allergy)
				items.append(item)
			}
		}
		
		return LunchMenu(self.date, title: data.menu.description, items: items)
	}
	
}

class GetMenuResponse: WebCallPayload {
	
	let menu: MenuPayload
	
	required init(unboxer: Unboxer) throws {
		self.menu = try unboxer.unbox(key: "item")
	}
	
}

class MenuPayload: WebCallPayload {
	
	let description: String?
	let items: [MenuItemPayload]
	
	required init(unboxer: Unboxer) throws {
		self.description = unboxer.unbox(key: "description")
		self.items = try unboxer.unbox(key: "items", allowInvalidElements: true)
	}
	
}

class MenuItemPayload: WebCallPayload {
	
	let type: String
	let name: String
	var allergy: String?
	
	required init(unboxer: Unboxer) throws {
		self.type = try unboxer.unbox(key: "type")
		self.name = try unboxer.unbox(key: "name")
		self.allergy = unboxer.unbox(key: "allergy")
	}
	
}
