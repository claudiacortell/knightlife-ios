//
//  DateSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

struct DateSchedule
{
	let date: EnscribedDate
	private var blocks: [ScheduleBlock] = []
	var subtitle: String?

	init(_ date: EnscribedDate, subtitle: String? = nil)
	{
		self.date = date
		self.subtitle = subtitle
	}
}

extension DateSchedule: Equatable
{
	var isEmpty: Bool
	{
		return self.blocks.isEmpty
	}
	
	mutating func addBlock(_ block: ScheduleBlock)
	{
		self.blocks.append(block)
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
	
	func getBlockBefore(_ block: ScheduleBlock) -> ScheduleBlock?
	{
		if !self.hasBlock(block: block)
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
		var val = 123
		if subtitle != nil { val ^= subtitle!.hashValue }
		for block in self.blocks
		{
			val ^= block.hashValue
		}
		return val
	}
}
