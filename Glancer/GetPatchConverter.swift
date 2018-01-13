//
//  GetPatchConverter.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/22/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class GetPatchConverter: WebCallResultConverter<ScheduleManager, GetPatchResponse, DateSchedule>
{
	let date: EnscribedDate
	
	init(_ date: EnscribedDate)
	{
		self.date = date
	}
	
	override func convert(_ response: GetPatchResponse) -> DateSchedule?
	{
		var daySchedule = DateSchedule(date, subtitle: response.subtitle, changed: response.changed ?? false)
				
		for block in response.blocks
		{
			if let blockId = BlockID.fromRaw(raw: block.blockId)
			{
				let startTime = EnscribedTime(raw: block.startTime)
				let endTime = EnscribedTime(raw: block.endTime)
				
				let variation = block.variation
				let associatedBlock: BlockID? = block.associatedBlock == nil ? nil : BlockID.fromRaw(raw: block.associatedBlock!)
				
				let customName = block.customName
				
				var color = block.overrideColor
				if color != nil && color!.count != 6
				{
					color = nil
				}
				
				if !startTime.valid || !endTime.valid || startTime.toDate() == nil || endTime.toDate() == nil
				{
					manager.out("Recieved an invalid start/end time: \(block.startTime), \(block.endTime)")
				} else
				{
					let scheduleBlock = ScheduleBlock(blockId: blockId, time: TimeDuration(startTime: startTime, endTime: endTime), variation: variation, associatedBlock: associatedBlock, customName: customName, color: color)
					daySchedule.addBlock(scheduleBlock)
				}
			} else
			{
				manager.out("Recieved an invalid block id: \(block.blockId)")
			}
		}
		
		return daySchedule
	}
}
