//
//  DateSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

struct DateNotice {
	
	let priority: Int
	let message: String
	
}

struct DateSchedule {
	
	fileprivate let uuid = UUID()
	
	let date: Date
	let day: DayOfWeek? // Used if this is say, a Tuesday with a Monday schedule. The actual date is a tuesday, but the standin Day is Day.monday

	let changed: Bool

	let notices: [DateNotice]
	let blocks: [Block]
	
}

extension DateSchedule: Equatable {
	
	var isEmpty: Bool {
		return self.getBlocks().isEmpty
	}
	
	func getFirstBlock() -> Block? {
		return self.getBlocks().first
	}
	
	func getLastBlock() -> Block? {
		return self.getBlocks().last
	}
	
	func getBlocks(_ allVariations: Bool = false, variation: Int? = nil) -> [Block] {
		let filterVariation = variation ?? ScheduleManager.instance.getVariation(self.date)
		return self.blocks.filter({ $0.variation == nil || allVariations || $0.variation! == filterVariation })
	}
	
	func hasBlock(_ id: BlockID) -> Bool {
		return getBlock(id) != nil
	}
	
	func hasBlock(_ block: Block) -> Bool {
		return self.getBlocks().contains(block)
	}
	
	func getBlock(_ id: BlockID) -> Block? {
		for block in self.getBlocks() {
			if block.id == id {
				return block
			}
		}
		return nil
	}
	
	func getBlockBefore(_ block: Block) -> Block? {
		if !self.hasBlock(block) {
			return nil
		}
		
		var found = false
		for cur in self.getBlocks().reversed() {
			if found {
				return cur
			}
			
			if cur == block {
				found = true
			}
		}
		return nil
	}
	
	func getBlockAfter(_ block: Block) -> Block? {
		if !self.hasBlock(block) {
			return nil
		}
		
		var found = false
		for cur in self.getBlocks() {
			if found {
				return cur
			}
			
			if cur == block {
				found = true
			}
		}
		return nil
	}
	
	func getBlocksAfter(_ block: Block) -> [Block] {
		if !self.hasBlock(block) {
			return []
		}
		
		var found = false
		var list: [Block] = []
		for item in self.getBlocks() {
			if found {
				list.append(item)
				continue
			}
			
			if block == item {
				found = true
			}
		}
		return list
	}
	
	func getBlocksBefore(_ block: Block) -> [Block] {
		if !self.hasBlock(block) {
			return []
		}
		
		var list: [Block] = []
		for cur in self.getBlocks() {
			if cur == block {
				return list
			}
			
			list.append(cur)
		}
		
		return list
	}
	
	static func ==(lhs: DateSchedule, rhs: DateSchedule) -> Bool {
		return lhs.uuid == rhs.uuid
	}
	
	var hashValue: Int {
		return self.uuid.hashValue
	}
	
}
