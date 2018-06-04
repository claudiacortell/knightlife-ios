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
		return self.getBlocks().isEmpty
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
		return self.getBlocks().contains(block)
	}
	
	func getBlock(_ id: BlockID) -> ScheduleBlock?
	{
		for block in self.getBlocks()
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
		for cur in self.getBlocks()
		{
			if cur == block
			{
				return previous
			}
			previous = cur
		}
		return nil
	}
	
	func getBlockAfter(_ block: ScheduleBlock) -> ScheduleBlock?
	{
		if !self.hasBlock(block)
		{
			return nil
		}
		
		var getNext = false
		for nextBlock in self.getBlocks() {
			if getNext {
				return nextBlock
			}
			
			if nextBlock == block {
				getNext = true
			}
		}
		return nil
	}
	
	func getBlocksAfter(_ block: ScheduleBlock) -> [ScheduleBlock] {
		
		if !self.hasBlock(block) {
			return []
		}
		
		var found = false
		var list: [ScheduleBlock] = []
		for block in self.getBlocks() {
			if found {
				list.append(block)
				continue
			}
			
			if block == block {
				found = true
			}
		}
		
		return list
	}
	
	func getBlocksBefore(_ block: ScheduleBlock) -> [ScheduleBlock] {
		
		if !self.hasBlock(block) {
			return []
		}
		
		var list: [ScheduleBlock] = []
		for block in self.getBlocks() {
			if block == block {
				return list
			}
			
			list.append(block)
		}
		
		return list
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
