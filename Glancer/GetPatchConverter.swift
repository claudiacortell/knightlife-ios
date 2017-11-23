//
//  GetPatchConverter.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/22/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class GetPatchConverter: WebCallResultConverter<ScheduleManager, GetPatchResponse, DaySchedule>
{
	override func convert(_ response: GetPatchResponse) -> DaySchedule?
	{
		var daySchedule = DaySchedule()
		for block in response.blocks
		{
			if let blockId = BlockID.fromRaw(raw: block.blockId)
			{
				let startTime = EnscribedTime(raw: block.startTime)
				let endTime = EnscribedTime(raw: block.endTime)
				let variation = block.variation
				
				if !startTime.valid || !endTime.valid || startTime.toDate() == nil || endTime.toDate() == nil
				{
					manager.out("Recieved an invalid start/end time: \(block.startTime), \(block.endTime)")
				} else
				{
					let scheduleBlock = ScheduleBlock(blockId: blockId, time: TimeDuration(startTime: startTime, endTime: endTime), variation: variation)
					daySchedule.blocks.append(scheduleBlock)
				}
			} else
			{
				manager.out("Recieved an invalid block id: \(block.blockId)")
			}
		}
		
		return daySchedule
	}
}
