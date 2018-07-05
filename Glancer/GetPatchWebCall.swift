//
//  GetPatchesWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

class GetPatchWebCall: UnboxWebCall<GetPatchResponse, DateSchedule> {
	
	let manager: ScheduleManager
	let date: EnscribedDate
	
	init(_ manager: ScheduleManager, date: EnscribedDate) {
		self.manager = manager
		self.date = date
		
		super.init(call: "schedule")
		
		self.parameter("dt", val: date.string)
	}
	
	override func convertToken(_ response: GetPatchResponse) -> DateSchedule? {
		var blocks: [ScheduleBlock] = []
		
		for block in response.blocks {
			if let blockId = BlockID.fromRaw(raw: block.blockId) {
				
				let startTime = EnscribedTime(raw: block.startTime)
				let endTime = EnscribedTime(raw: block.endTime)
				
				let variation = block.variation
//				let associatedBlock: BlockID? = block.associatedBlock == nil ? nil : BlockID.fromRaw(raw: block.associatedBlock!)
				
				let customName = block.customName
				
				var color = block.overrideColor
				if color != nil && color!.count != 6 {
					color = nil
				}
				
				if !startTime.valid || !endTime.valid || startTime.toDate() == nil || endTime.toDate() == nil {
					manager.out("Recieved an invalid start/end time: \(block.startTime), \(block.endTime)")
				} else {
					let scheduleBlock = ScheduleBlock(blockId: blockId, time: TimeDuration(startTime: startTime, endTime: endTime), variation: variation, customName: customName, color: color)
					blocks.append(scheduleBlock)
				}
			} else {
				manager.out("Recieved an invalid block id: \(block.blockId)")
			}
		}
		
		var standinDayId: Day?
		if response.replaceDayId != nil {
			standinDayId = Day.fromId(response.replaceDayId!)
		}
		
		let daySchedule = DateSchedule(date, blocks: blocks, subtitle: response.subtitle, changed: response.changed ?? false, standinDayId: standinDayId)
		return daySchedule
	}

}
