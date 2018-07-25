//
//  DaySchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

struct DaySchedule {
	
	fileprivate let uuid = UUID()
	
	let day: DayOfWeek
	let blocks: [Block]
	
}

extension DaySchedule: Equatable {
	
	func getBlocks(_ allVariations: Bool = false, variation: Int? = nil) -> [Block] {
		var blocks: [Block] = []
		
		let filterVariation = variation ?? ScheduleManager.instance.getVariation(self.day)
		for block in self.blocks {
			if block.variation == nil || allVariations || block.variation == filterVariation {
				blocks.append(block)
			}
		}
		
		return blocks
	}
	
	func hasBlock(id: BlockID) -> Bool {
		return getBlock(id: id) != nil
	}
	
	func hasBlock(block: Block) -> Bool {
		return self.blocks.contains(block)
	}
	
	func getBlock(id: BlockID) -> Block? {
		for block in self.blocks {
			if block.id == id {
				return block
			}
		}
		return nil
	}
	
	static func ==(lhs: DaySchedule, rhs: DaySchedule) -> Bool {
		return lhs.uuid == rhs.uuid
	}
	
	var hashValue: Int {
		return self.uuid.hashValue
	}
	
}
