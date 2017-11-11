//
//  ScheduleManage.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class ScheduleManager: Manager
{
	static let instance = ScheduleManager()
	
	var scheduleTemplate: [DayID: BlockList]
	var schedulePatches: [EnscribedDate: BlockList]
	
	var lastTemplateFetch: CallResult? = nil
	var lastPatchFetch: CallResult? = nil
	
	init()
	{
		self.scheduleTemplate = [:]
		self.schedulePatches = [:]
		
		super.init(name: "Schedule Manager")
	}
	
	func retrieveBlockList(date: EnscribedDate = TimeUtils.todayEnscribed) -> BlockList?
	{
		// Search for patches
		if let patchBlockList = schedulePatches[date]
		{
			return patchBlockList
		}
		
		// Get the loaded template for its day ID.
		if let day = TimeUtils.getDayOfWeek(date)
		{
			return scheduleTemplate[day]
		}
		return nil
	}
	
	func templateResponded(response: GetScheduleResponse)
	{
		var result: CallResult = .success
		
		var dayList: [DayID: BlockList] = [:]
		for day in response.days
		{
			if let dayId = DayID.fromRaw(raw: day.dayId)
			{
				var blockList: [ScheduleBlock] = []
				for block in day.blocks
				{
					if let blockId = BlockID.fromRaw(raw: block.blockId)
					{
						let startTime = EnscribedTime(raw: block.startTime)
						let endTime = EnscribedTime(raw: block.endTime)
						
						if !startTime.valid || !endTime.valid || startTime.toDate() == nil || endTime.toDate() == nil
						{
							out("Recieved an invalid start/end time: \(block.startTime), \(block.endTime)")
							result = .error
						} else
						{
							let scheduleBlock = ScheduleBlock(blockId: blockId, time: TimeDuration(startTime: startTime, endTime: endTime))
							blockList.append(scheduleBlock)
						}
					} else
					{
						out("Recieved an invalid block id: \(block.blockId)")
						result = .error
					}
				}
				
				if dayList[dayId] != nil
				{
					out("Already set information for day: \(dayId.rawValue)")
					result = .error
				} else
				{
					let blocks = BlockList(blocks: blockList)
					dayList[dayId] = blocks
				}
			} else
			{
				out("Recieved an invalid day id: \(day.dayId)")
				result = .error
			}
		}
		
		self.lastTemplateFetch = result
		self.scheduleTemplate = dayList
	}
//
//	func patchesListResponded(response: GetPatchesListResponse)
//	{
//
//	}
//
	func patchesResponded(response: GetPatchesResponse)
	{
		let patchDate = EnscribedDate(raw: response.dayId)
		if patchDate.valid && patchDate.toDate() != nil
		{
			var result: CallResult = .success

			var blockList: [ScheduleBlock] = []
			for block in response.blocks
			{
				if let blockId = BlockID.fromRaw(raw: block.blockId)
				{
					let startTime = EnscribedTime(raw: block.startTime)
					let endTime = EnscribedTime(raw: block.endTime)
					
					if !startTime.valid || !endTime.valid || startTime.toDate() == nil || endTime.toDate() == nil
					{
						out("Recieved an invalid start/end time: \(block.startTime), \(block.endTime)")
						result = .error
					} else
					{
						let scheduleBlock = ScheduleBlock(blockId: blockId, time: TimeDuration(startTime: startTime, endTime: endTime))
						blockList.append(scheduleBlock)
					}
				} else
				{
					out("Recieved an invalid block id: \(block.blockId)")
					result = .error
				}
			}
			
			self.schedulePatches[patchDate] = BlockList(blocks: blockList)
			self.lastPatchFetch = result
		} else
		{
			out("Recieved an invalid date: \(response.dayId)")
			self.lastPatchFetch = .failure
		}
	}
}
