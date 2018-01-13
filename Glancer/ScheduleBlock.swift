//
//  ScheduleBlock.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct ScheduleBlock
{
	let blockId: BlockID
	let time: TimeDuration
	let variation: Int?
	let associatedBlock: BlockID?
	let customName: String? // Only used when the block ID is Custom
	let color: String?
}

extension ScheduleBlock: Equatable
{
	static func ==(lhs: ScheduleBlock, rhs: ScheduleBlock) -> Bool
	{
		return lhs.hashValue == rhs.hashValue
	}
	
	var hashValue: Int
	{
		var id = 1
		
		id ^= self.blockId.hashValue
		id ^= self.time.hashValue
		id ^= self.variation ?? 1
		id ^= self.associatedBlock?.hashValue ?? 1
		id ^= self.customName?.hashValue ?? 1
		id ^= self.color?.hashValue ?? 1
		
		return id
	}
}
