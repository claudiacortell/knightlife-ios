//
//  DateSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

struct DateSchedule
{
	let date: EnscribedDate
	let blocks: [ScheduleBlock]
	let subtitle: String?
	let changed: Bool
	let standinDayId: Day? // Used if this is say, a Tuesday with a Monday schedule. The actual date is a tuesday, but the standin Day is Day.monday

	init(_ date: EnscribedDate, blocks: [ScheduleBlock], subtitle: String? = nil, changed: Bool = false, standinDayId: Day? = nil)
	{
		self.date = date
		self.blocks = blocks
		self.subtitle = subtitle
		self.changed = changed
		self.standinDayId = standinDayId
	}
}

extension DateSchedule: Equatable
{
	var isEmpty: Bool
	{
		return self.blocks.isEmpty
	}
	
	func getFirstBlock() -> ScheduleBlock?
	{
		let blocks = self.getBlocks()
		if blocks.count > 0
		{
			return blocks.first!
		}
		return nil
	}
	
	func getLastBlock() -> ScheduleBlock?
	{
		let blocks = self.getBlocks()
		if blocks.count > 0
		{
			return blocks.last!
		}
		return nil
	}
	
	func getBlocks(_ allVariations: Bool = false, variation: Int? = nil) -> [ScheduleBlock]
	{
		var blocks: [ScheduleBlock] = []
		
		let newVariation = variation ?? ScheduleManager.instance.getVariation(self.date)
		for block in self.blocks
		{
			if block.variation == nil || allVariations || block.variation == newVariation
			{
				blocks.append(block)
			}
		}
		return blocks
	}
	
	func getBlockByHash(_ hash: Int) -> ScheduleBlock?
	{
		for block in self.blocks
		{
			if block.hashValue == hash
			{
				return block
			}
		}
		return nil
	}
	
	func hasBlock(_ id: BlockID) -> Bool
	{
		return getBlock(id) != nil
	}
	
	func hasBlock(_ block: ScheduleBlock) -> Bool
	{
		return self.blocks.contains(block)
	}
	
	func getBlock(_ id: BlockID) -> ScheduleBlock?
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
	
	func getBlockBefore(_ block: ScheduleBlock) -> ScheduleBlock?
	{
		if !self.hasBlock(block)
		{
			return nil
		}
		
		var previous: ScheduleBlock? = nil
		for cur in self.blocks
		{
			if cur == block
			{
				return previous
			}
			previous = cur
		}
		return nil
	}
	
	static func ==(lhs: DateSchedule, rhs: DateSchedule) -> Bool
	{
		if lhs.blocks.count != rhs.blocks.count
		{
			return false
		}
		
		if lhs.subtitle != rhs.subtitle
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
		var val = 1
		
		val ^= date.hashValue
		val ^= self.changed.hashValue
		val ^= self.subtitle?.hashValue ?? 1
		
		for block in self.blocks
		{
			val ^= block.hashValue
		}
		return val
	}
}
