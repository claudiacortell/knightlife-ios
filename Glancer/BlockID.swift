//
//  BlockID.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

enum BlockID: String
{
	case
	a = "A",
	b = "B",
	c = "C",
	d = "D",
	e = "E",
	f = "F",
	g = "G",
	x = "X",
    lunch = "Lunch",
	activities = "Activities",
	lab = "Lab",
	custom = "Custom",
	advisory = "Advisory"
	
	var id: Int
	{
		return BlockID.values().index(of: self)!
	}
	
	var displayName: String
	{
		if BlockID.regularBlocks().contains(self)
		{
			return "\(self.rawValue) Block"
		}
		return self.rawValue
	}
	
	var displayLetter: String
	{
		if BlockID.regularBlocks().contains(self) || self.rawValue.count <= 1
		{
			return self.rawValue
		} else
		{
			return Utils.substring(self.rawValue, start: 0, distance: 2)
		}
	}
	
	static func fromRaw(raw: String) -> BlockID?
	{
		for block in BlockID.values()
		{
			if block.rawValue == raw
			{
				return block
			}
		}
		return nil
	}
	
	static func fromId(_ id: Int) -> BlockID?
	{
		for block in BlockID.values()
		{
			if block.id == id
			{
				return block
			}
		}
		return nil
	}
	
	static func values() -> [BlockID] { return [.a, .b, .c, .d, .e, .f, .g, .x, .custom, .activities, .lab, .lunch, .advisory] }
	static func regularBlocks() -> [BlockID] { return [.a, .b, .c, .d, .e, .f, .g, .x] }
}
