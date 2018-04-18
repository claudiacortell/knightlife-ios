//
//  GetScheduleWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Charcore

class GetScheduleWebCall: WebCall<GetScheduleResponse, [Day: WeekdaySchedule]>
{
	let manager: ScheduleManager
	
	init(_ manager: ScheduleManager)
	{
		self.manager = manager
		super.init(call: "schedule/template")
	}
	
	override func handleTokenConversion(_ response: GetScheduleResponse) -> [Day : WeekdaySchedule]?
	{
		var dayList: [Day: WeekdaySchedule] = [:]
		for day in response.days
		{
			if let dayId = Day.fromRaw(raw: day.dayId)
			{
				var blocks: [ScheduleBlock] = []
				for block in day.blocks
				{
					if let blockId = BlockID.fromRaw(raw: block.blockId)
					{
						let startTime = EnscribedTime(raw: block.startTime)
						let endTime = EnscribedTime(raw: block.endTime)
						let variation = block.variation
						let associatedBlock: BlockID? = block.associatedBlock == nil ? nil : BlockID.fromRaw(raw: block.associatedBlock!)
						
						if !startTime.valid || !endTime.valid || startTime.toDate() == nil || endTime.toDate() == nil
						{
							manager.out("Recieved an invalid start/end time: \(block.startTime), \(block.endTime)")
						} else
						{
							let scheduleBlock = ScheduleBlock(blockId: blockId, time: TimeDuration(startTime: startTime, endTime: endTime), variation: variation, customName: nil, color: nil)
							blocks.append(scheduleBlock)
						}
					} else
					{
						manager.out("Recieved an invalid block id: \(block.blockId)")
					}
				}
				
				let schedule = WeekdaySchedule(dayId, blocks: blocks)

				if dayList[dayId] != nil
				{
					manager.out("Already set information for day: \(dayId.rawValue)")
				} else
				{
					dayList[dayId] = schedule
				}
			} else
			{
				manager.out("Recieved an invalid day id: \(day.dayId)")
			}
		}
		return dayList
	}
}
