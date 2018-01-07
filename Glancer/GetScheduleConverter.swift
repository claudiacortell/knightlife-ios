//
//  GetScheduleConverter.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/22/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class GetScheduleConverter: WebCallResultConverter<ScheduleManager, GetScheduleResponse, [DayID: WeekdaySchedule]>
{
	override func convert(_ response: GetScheduleResponse) -> [DayID : WeekdaySchedule]?
	{
		var dayList: [DayID: WeekdaySchedule] = [:]
		for day in response.days
		{
			if let dayId = DayID.fromRaw(raw: day.dayId)
			{
				var schedule = WeekdaySchedule(dayId)
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
							let scheduleBlock = ScheduleBlock(blockId: blockId, time: TimeDuration(startTime: startTime, endTime: endTime), variation: variation, associatedBlock: associatedBlock, customName: nil)
							schedule.addBlock(scheduleBlock)
						}
					} else
					{
						manager.out("Recieved an invalid block id: \(block.blockId)")
					}
				}
				
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
