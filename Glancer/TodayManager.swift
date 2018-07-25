//
//  TodayManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 6/3/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class TodayManager: Manager {
	
	enum ScheduleState {
		case ERROR
		case NULL
		
		case NO_CLASS
		
		case BEFORE_SCHOOL
		case BETWEEN_CLASS
		case IN_CLASS
		
		case AFTER_SCHOOL
	}
	
	static let instance = TodayManager()
	
	private(set) var today: Date
	
	private(set) var todaySchedule: DateSchedule?
	private(set) var fetchError: Error?
	
	init() {
		self.today = Date.today
		super.init("Today")
		
		self.registerListeners()
		ScheduleManager.instance.loadSchedule(date: self.today)
	}
	
	private func registerListeners() {
		ScheduleManager.instance.getPatchWatcher(date: self.today).onSuccess(self) {
			schedule in
			self.patchDidLoad(schedule: schedule)
		}
		
		ScheduleManager.instance.getPatchWatcher(date: self.today).onFailure(self) {
			error in
			self.patchDidFailLoad(error: error)
		}
	}
	
	private func patchDidLoad(schedule: DateSchedule) {
		self.todaySchedule = schedule
	}
	
	private func patchDidFailLoad(error: Error) {
		self.todaySchedule = nil
	}
	
	func getCurrentBlock() -> Block? {
		if self.todaySchedule == nil {
			return nil
		}
		
		let current = Date()
		let schedule = self.todaySchedule!
		
		for block in schedule.blocks {
			let blockStart = Calendar.normalizedCalendar.date block.time.start
			let blockEnd = block.time.end
			
			blockStart.
		}
	}
	
	func getCurrentBlock(_ schedule: DateSchedule) -> Block? {
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

	func getCurrentScheduleInfo(_ schedule: DateSchedule) -> (minutesRemaining: (years: Int, days: Int, hours: Int, minutes: Int, seconds: Int), curBlock: Block?, nextBlock: Block?, scheduleState: ScheduleState) {
		if schedule.date != TimeUtils.todayEnscribed {
			return ((-1, -1, -1, -1, -1), nil, nil, .ERROR)
		}
		
		if schedule.getBlocks().isEmpty {
			return ((-1, -1, -1, -1, -1), nil, nil, .NO_CLASS)
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
					return (timeToSchoolStart, nil, schedule.getFirstBlock()!, .BEFORE_SCHOOL)
				}
				
				if schedule.getLastBlock() == block && curDate >= block.time.endTime.toDate()! { // After school
					return ((-1, -1, -1, -1, -1), nil, nil, .AFTER_SCHOOL)
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
		return ((-1, -1, -1, -1, -1), nil, nil, .ERROR)
	}
	
}
