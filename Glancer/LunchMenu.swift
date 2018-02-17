//
//  LunchMenu.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

enum LunchMenuItemType: String
{
	case
	main = "main",
	accompaniment = "accompaniment",
	side = "side",
	pasta = "pasta",
	soup = "soup"
	
	static let values: [LunchMenuItemType] = [.main, .accompaniment, .side, .pasta, .soup]
	
	static func fromString(_ val: String) -> LunchMenuItemType?
	{
		for value in LunchMenuItemType.values
		{
			if value.rawValue == val
			{
				return value
			}
		}
		return nil
	}
}

struct LunchMenu
{
	let date: EnscribedDate
	let title: String?
	let items: [LunchMenuItem]
	
	init(_ date: EnscribedDate, title: String?, items: [LunchMenuItem])
	{
		self.date = date
		self.title = title
		self.items = items
	}
}

struct LunchMenuItem
{
	let type: LunchMenuItemType
	let name: String
	let allergy: String?
	
	init(_ type: LunchMenuItemType, name: String, allergy: String?)
	{
		self.type = type
		self.name = name
		self.allergy = allergy
	}
}
