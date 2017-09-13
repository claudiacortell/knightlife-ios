//
//  ClassMetaManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class ClassManager
{
	static let currentSchoolYear = "2017-2018"
	
	let customMeta: [String: BlockMeta] = [:] // Block ID to meta
	let weekSchedule: [String: Day]
	
	init()
	{
		
	}
	
	func loadBlocks()
	{
		
	}
}

struct Day
{
	var dayId: String // M, T, W, Th, F
	var blocks: [String: Block] // Class ID to Block
}

struct Block
{
	var blockId: String // E.G. A, B, C, D, E
	var startTime: String
	var endTime: String
}

struct BlockMeta
{
	var blockId: String // E.G. A, B, C, D, E (Corresponds to Class ID)
	var customName: String
	var customColor: String
}
