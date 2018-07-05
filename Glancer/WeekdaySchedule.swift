//
//  BlockList.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

struct WeekdaySchedule
{
	let dayId: Day
	let blocks: [ScheduleBlock]
	
	init(_ day: Day, blocks: [ScheduleBlock])
	{
		self.dayId = day
		self.blocks = blocks
	}
}

extension WeekdaySchedule: Equatable
{
	func getBlocks(_ allVariations: Bool = false, variation: Int? = nil) -> [ScheduleBlock]
	{
		var blocks: [ScheduleBlock] = []
		let referenceVariation: Int = variation ?? ScheduleManager.instance.getVariation(self.dayId)
		
		for block in self.blocks
		{
			if block.variation == nil || allVariations || block.variation == referenceVariation
			{
				blocks.append(block)
			}
		}
		return blocks
	}
	
	func getBlockByID(_ id: UUID) -> ScheduleBlock?
	{
		for block in self.blocks
		{
			if block.ID == id
			{
				return block
			}
		}
		return nil
	}
	
	func hasBlock(id: BlockID) -> Bool
	{
		return getBlock(id: id) != nil
	}
	
	func hasBlock(block: ScheduleBlock) -> Bool
	{
		return self.blocks.contains(block)
	}
	
	func getBlock(id: BlockID) -> ScheduleBlock?
	{
		for block in self.blocks
		{
			if block.blockId == id
			{
				return block
			}
		}
		return nil
	}
	
	static func ==(lhs: WeekdaySchedule, rhs: WeekdaySchedule) -> Bool
	{
		if lhs.blocks.count != rhs.blocks.count
		{
			return false
		}
		
		for i in 0..<lhs.blocks.count
		{
			if lhs.blocks[i] != rhs.blocks[i]
			{
				return false
			}
		}
		
		return true
	}
	
	var hashValue: Int
	{
		var val = 123
		for block in self.blocks
		{
			val ^= block.hashValue
		}
		return val
	}
}
