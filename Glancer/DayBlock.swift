//
//  DayBlock.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct DayBlock // Used for identifying a block at a future date.
{
	let date: EnscribedDate
	let id: BlockID
	
	init(date: EnscribedDate, id: BlockID)
	{
		self.date = date
		self.id = id
	}
}

extension DayBlock: Hashable
{
	static func ==(lhs: DayBlock, rhs: DayBlock) -> Bool
	{
		return
			lhs.date == rhs.date &&
			lhs.id == rhs.id
	}
	
	var hashValue: Int
	{
		return self.date.hashValue ^ self.id.hashValue
	}
}
