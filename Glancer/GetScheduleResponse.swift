//
//  GetScheduleResponse.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Unbox

struct GetScheduleResponse: WebCallResult
{
	var days: [GetScheduleResponseDay]
	
	init(unboxer: Unboxer) throws
	{
		self.days = try unboxer.unbox(keyPath: "schedule_template.days", allowInvalidElements: false)
	}
}

struct GetScheduleResponseDay: WebCallResult
{
	var dayId: String
	var blocks: [GetScheduleResponseBlock]
	
	init(unboxer: Unboxer) throws
	{
		self.dayId = try unboxer.unbox(key: "dayId")
		self.blocks = try unboxer.unbox(key: "blocks")
	}
}

struct GetScheduleResponseBlock: WebCallResult
{
	var blockId: String
	var startTime: String
	var endTime: String

	var variation: Int?
	var associatedBlock: String?
	
	init(unboxer: Unboxer) throws
	{
		self.blockId = try unboxer.unbox(key: "blockId")
		self.startTime = try unboxer.unbox(key: "startTime")
		self.endTime = try unboxer.unbox(key: "endTime")
		
		self.variation = unboxer.unbox(key: "variation")
		self.associatedBlock = unboxer.unbox(key: "associatedBlock")
	}
}
