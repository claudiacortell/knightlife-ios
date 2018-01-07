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
}

extension ScheduleBlock: Equatable
{
	static func ==(lhs: ScheduleBlock, rhs: ScheduleBlock) -> Bool
	{
		return
			lhs.blockId == rhs.blockId &&
			lhs.time == rhs.time
	}
	
	var hashValue: Int
	{
		var id = self.blockId.hashValue ^ self.time.hashValue
		if self.variation != nil
		{
			id ^= self.variation!
		}
		return id
	}
}
