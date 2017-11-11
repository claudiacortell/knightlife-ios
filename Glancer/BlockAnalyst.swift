//
//  BlockAnalyst.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class BlockAnalyst
{
	fileprivate var block: Block!
	
	var meta: BlockMeta?
	{
		get
		{
			if let meta = UserPrefsManager.instance.getMeta(id: self.block.blockId)
			{
				return meta
			}
			return nil
		}
	}
	
	init(_ block: Block)
	{
		self.block = block
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
		if block.blockId == .lab
		{
			if let previous = block.analyst.getPreviousBlock() // If it's a lab return the previous block letter + L
			{
				return Utils.substring(previous.analyst.getDisplayLetter(), start: 0, distance: 1) + "L" // Return the first two letters. This should only return the first letter if it's a 1 letter string.
			}
		}
		
		if block.hasOverridenDisplayName
		{
			let displayName = block.overrideDisplayName!
			if displayName.contains(" ") // 2+ words then make the block letter the first letter of each
			{
				let split = displayName.split(separator: " ")
				var built = ""
				var count = 0
				
				let acceptableCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".characters
				for word in split
				{
					if count >= 2 { break }
					if word.first != nil && acceptableCharacters.contains(word.first!)
					{
						built += String(describing: word.first!)
					}
					count+=1
				}
				
				if built.count >= 2
				{
					return built
				}
			}
			
			return Utils.substring(displayName, start: 0, distance: 2)
		}
		
		let id = self.block.blockId.rawValue // Return the first two letters. This should only return the first letter if it's a 1 letter string.
		if self.block.hasLunchBlockNumber
		{
			return "\(id)\(self.block.lunchBlockNumber!)"
		}
		
		if id.count > 2
		{
			return Utils.substring(id, start: 0, distance: 2)
		}
		
		return id
	}
	
	func getDisplayName(_ appendBlock: Bool = true) -> String // E.G. X Block
	{
		if self.block.blockId == .lab
		{
			let previous = getPreviousBlock()
			if previous != nil
			{
				return "\(previous!.analyst.getDisplayName(false)) Lab" // Return a new block analyst to get the display name if this is a lab block
			}
		}
		
		if block.hasOverridenDisplayName
		{
			return block.overrideDisplayName!
		}
		
		if let meta = self.meta
		{
			if let name = meta.customName
			{
				return name
			}
		}
		
		if self.block.blockId == .activities || self.block.blockId == .custom
		{
			return block.blockId.rawValue
		}
		
		return block.blockId.rawValue + (appendBlock ? " Block" : "")
	}
	
	func getColor() -> String
	{
		if self.block.blockId == .lab
		{
			let previous = getPreviousBlock()
			if previous != nil
			{
				return previous!.analyst.getColor() // Return a new block analyst to get the color if this is a lab block
			}
		}
		
		if let meta = self.meta
		{
			return meta.customColor
		}
		return "999999"
	}
	
	func getRoom() -> String
	{
		if self.block.isLunchBlock
		{
			return ""
		}
		
		if let meta = self.meta
		{
			return meta.roomNumber == nil ? "" : meta.roomNumber!
		}
		return ""
	}
	
	func isLastBlock() -> Bool
	{
		return self.block.isLastBlock
	}
	
	func isFirstBlock() -> Bool
	{
		return self.block.isFirstBlock
	}
	
	func getNextBlock() -> Block?
	{
		if isLastBlock() { return nil }
		
//		if let blocks = ScheduleManager.instance.blockList(id: self.block.weekday)
//		{
//			var found = false // If the block has been found return the next one in series
//			for block in blocks
//			{
//				if found { return block }
//				if block == self.block { found = true } // Identify the current iterator block as this one.
//			}
//			return nil
//		} else
//		{
//			return nil
//		}

		return nil
	}
	
	func getPreviousBlock() -> Block?
	{
		//		Debug.out("Checking previous block")
		if isFirstBlock() { return nil }
		
		//		Debug.out("Not previous block")
		
//		if let blocks = ScheduleManager.instance.blockList(id: self.block.weekday)
//		{
//			//			Debug.out("Block list")
//
//			var found = false // If the block has been found return the next one in series
//			for block in blocks.reversed()
//			{
//				if found { return block  }
//				if block == self.block { found = true } // Identify the current iterator block as this one.
//			}
//			return nil
//		} else
//		{
//			return nil
//		}
		return nil
	}
	
	func hasPassed() -> Bool
	{
		let date = Date()
		return date >= self.getEndTime().asDate()
	}
}
