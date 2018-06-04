//
//  TodayManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 6/3/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

class TodayManager: Manager {
	
	enum ScheduleState
	{
		case ERROR, NO_CLASS, BEFORE_SCHOOL, BETWEEN_CLASS, IN_CLASS, AFTER_SCHOOL
	}
	
	static let instance = TodayManager()
	
	init() {
		super.init("Today")
	}
	
	func getCurrentBlock(_ schedule: DateSchedule) -> ScheduleBlock? {
		if schedule.date != TimeUtils.todayEnscribed {
			return nil
		}
		
		let current = Date()
		for block in schedule.getBlocks() {
			if current >= block.time.startTime.toDate()! && current < block.time.endTime.toDate()! {
				return block
			}
		}
		return nil
	}

	func getCurrentScheduleInfo(_ schedule: DateSchedule) -> (minutesRemaining: (hours: Int, minutes: Int), curBlock: ScheduleBlock?, nextBlock: ScheduleBlock?, scheduleState: ScheduleState) {
		if schedule.date != TimeUtils.todayEnscribed {
			return ((-1, -1), nil, nil, .ERROR)
		}
		
		if schedule.getBlocks().isEmpty {
			return ((-1, -1), nil, nil, .NO_CLASS)
		}
		
		let curBlock = self.getCurrentBlock(schedule)
		if curBlock != nil { // In class
			let nextBlock = schedule.getBlockAfter(curBlock!)
			let minutesToEnd = TimeUtils.timeToDateInMinutes(to: curBlock!.time.endTime.toDate()!)
			
			return (minutesToEnd, curBlock!, nextBlock, .IN_CLASS) // Return the time until the end of the class
		} else { // Not in class
			let curDate = Date()
			for block in schedule.getBlocks() {
				
				if schedule.getFirstBlock() == block && curDate < block.time.startTime.toDate()! { // Before school
					let timeToSchoolStart = TimeUtils.timeToDateInMinutes(to: block.time.startTime.toDate()!)
					return (timeToSchoolStart, nil, nil, .BEFORE_SCHOOL)
				}
				
				if schedule.getLastBlock() == block && curDate >= block.time.endTime.toDate()! { // After school
					return ((-1, -1), nil, nil, .AFTER_SCHOOL)
				}
				
				let nextBlock = schedule.getBlockAfter(block)
				if nextBlock != nil { // Inbetween classes
					if curDate >= block.time.endTime.toDate()! && curDate < nextBlock!.time.endTime.toDate()! {
						let timeToNextBlock = TimeUtils.timeToDateInMinutes(to: nextBlock!.time.endTime.toDate()!)
						return (timeToNextBlock, block, nextBlock, .BETWEEN_CLASS)
					}
				}
			}
		}
		return ((-1, -1), nil, nil, .ERROR)
	}
	
}
