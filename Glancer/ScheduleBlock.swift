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
	let ID: UUID = UUID()
	
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
		return lhs.ID == rhs.ID
	}
	
	var hashValue: Int
	{
		return self.ID.hashValue
	}
}
