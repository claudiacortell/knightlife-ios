//
//  LunchMenu.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

enum LunchMenuItemType: String {
	
	case
	main = "main",
	accompaniment = "accompaniment",
	side = "side",
	pasta = "pasta",
	salad = "salad",
	soup = "soup",
	other = "other"

	static var values: [LunchMenuItemType] = [.main, .accompaniment, .side, .pasta, .salad, .soup, .other]
	
}

struct LunchMenu {
	
	let date: Date
	let title: String?
	let items: [LunchMenuItem]
	
	init(_ date: Date, title: String?, items: [LunchMenuItem]) {
		self.date = date
		self.title = title
		self.items = items
	}
	
}

struct LunchMenuItem {
	
	let type: LunchMenuItemType
	let name: String
	let allergy: String?
	
	init(_ type: LunchMenuItemType, name: String, allergy: String?) {
		self.type = type
		self.name = name
		self.allergy = allergy
	}
	
}
