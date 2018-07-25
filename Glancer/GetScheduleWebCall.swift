//
//  GetScheduleWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class GetScheduleWebCall: UnboxWebCall<GetScheduleResponse, [DayOfWeek: DaySchedule]> {
	
	init() {
		super.init(call: "schedule/template")
	}
	
	override func convertToken(_ response: GetScheduleResponse) -> [DayOfWeek: DaySchedule]? {
		var dayList: [DayOfWeek: DaySchedule] = [:]
		for responseDay in response.days {
			guard let dayId = DayOfWeek.fromShortName(shortName: responseDay.dayId) else {
				print("Recieved an invalid day id: \(responseDay.dayId)")
				continue
			}
			
			var blocks: [Block] = []
			
			for responseBlock in responseDay.blocks {
				guard let blockId = BlockID.fromStringValue(name: responseBlock.blockId) else {
					print("Recieved an invalid block id: \(responseBlock.blockId)")
					continue
				}
				
				guard let startTime = Date.fromWebTime(string: responseBlock.startTime), let endTime = Date.fromWebTime(string: responseBlock.endTime) else {
					print("Recieved an invalid start/end time")
					continue
				}

				let variation = responseBlock.variation
				
				let block = Block(id: blockId, time: TimeDuration(start: startTime, end: endTime), variation: variation, customName: nil, color: nil)
				blocks.append(block)
			}
			
			let schedule = DaySchedule(day: dayId, blocks: blocks)
			
			if dayList[dayId] != nil {
				print("Already set information for day: \(dayId.rawValue)")
			} else {
				dayList[dayId] = schedule
			}
		}
		return dayList
	}
	
}

struct GetScheduleResponse: WebCallPayload {
	
	var days: [GetScheduleResponseDay]
	
	init(unboxer: Unboxer) throws {
		self.days = try unboxer.unbox(keyPath: "days", allowInvalidElements: false)
	}
	
}

struct GetScheduleResponseDay: WebCallPayload {
	
	var dayId: String
	var blocks: [GetScheduleResponseBlock]
	
	init(unboxer: Unboxer) throws {
		self.dayId = try unboxer.unbox(key: "id")
		self.blocks = try unboxer.unbox(key: "blocks")
	}
	
}

struct GetScheduleResponseBlock: WebCallPayload {
	
	var blockId: String
	var startTime: String
	var endTime: String
	
	var variation: Int?
	
	init(unboxer: Unboxer) throws {
		self.blockId = try unboxer.unbox(key: "id")
		self.startTime = try unboxer.unbox(key: "start")
		self.endTime = try unboxer.unbox(key: "end")
		
		self.variation = unboxer.unbox(key: "variation")
	}
	
}
