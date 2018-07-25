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
		
		for item in data.items {
			if let type = LunchMenuItemType(rawValue: item.type) {
				let item = LunchMenuItem(type, name: item.name, allergy: item.allergy)
				items.append(item)
			}
		}
		
		return LunchMenu(self.date, title: data.caption, items: items)
	}
	
}

class GetMenuResponse: WebCallPayload {
	
	let caption: String?
	let items: [GetMenuResponseItem]
	
	required init(unboxer: Unboxer) throws {
		self.caption = unboxer.unbox(key: "caption")
		self.items = try unboxer.unbox(keyPath: "items", allowInvalidElements: false)
	}
	
}

class GetMenuResponseItem: WebCallPayload {
	
	let type: String
	let name: String
	var allergy: String?
	
	required init(unboxer: Unboxer) throws {
		self.type = try unboxer.unbox(key: "type")
		self.name = try unboxer.unbox(key: "name")
		self.allergy = unboxer.unbox(key: "allergy")
	}
	
}
