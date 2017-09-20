//
//  BlockAnalyst.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/19/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class BlockAnalyst
{
	let block: Block
	
	var meta: UserPrefsManager.BlockMeta?
	var hasMeta: Bool
	{
		get
		{
			return self.meta != nil
		}
	}
	
	init(block: Block)
	{
		self.block = block
		setMeta()
	}
	
	private func setMeta()
	{
		self.meta = UserPrefsManager.instance.blockMeta[self.block.blockId]
	}
	
	func getStartTime() -> TimeContainer
	{
		return self.block.overrideStartTime ?? self.block.startTime
	}
	
	func getEndTime() -> TimeContainer
	{
		return self.block.overrideEndTime ?? self.block.endTime
	}
	
	func getDisplayLetter() -> String
	{
		if block.hasOverridenDisplayName
		{
			var firstTwoLetters = Utils.substring(block.overrideDisplayName!, StartIndex: 0, EndIndex: 2)
			let firstLetter = String(describing: firstTwoLetters.characters.first)
			
			return BlockID.fromRaw(raw: firstLetter) == nil ? firstLetter : firstTwoLetters // If the first letter isalready a block then return the first two letters
		}
		
		return Utils.substring(self.block.blockId.rawValue, StartIndex: 0, EndIndex: 2) // Return the first two letters. This should only return the first letter if it's a 1 letter string.
	}
	
	func getDisplayName() -> String // E.G. X Block
	{
		if block.hasOverridenDisplayName
		{
			return block.overrideDisplayName!
		}
		
		if self.hasMeta && self.meta!.customName != nil
		{
			return self.meta!.customName!
		}
		
		return block.blockId.rawValue + " Block"
	}
	
	func getColor() -> String
	{
		if self.hasMeta
		{
			return self.meta!.customColor
		}
		return "999999"
	}
	
	func isLastBlock() -> Bool
	{
		return self.block.isLastBlock
	}
	
	func getNextBlock() -> Block?
	{
		if isLastBlock() { return nil }
		
		if let blocks = ScheduleManager.instance.weekSchedule[self.block.weekday]?.blocks
		{
			var found = false // If the block has been found return the next one in series
			for block in blocks
			{
				if found { return block }
				if block == self.block { found = true } // Identify the current iterator block as this one.
			}
			return nil
		} else
		{
			return nil
		}
	}
}
