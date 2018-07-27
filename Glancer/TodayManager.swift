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
	
	enum TodayScheduleState: Equatable {
		
		case LOADING
		
		case ERROR
		case NULL
		
		case NO_CLASS(DateSchedule)
		
		case BEFORE_SCHOOL(DateSchedule, Block, Int)
		case BETWEEN_CLASS(DateSchedule, Block, Int)
		case IN_CLASS(DateSchedule, Block, Block?, Int)
		
		case AFTER_SCHOOL(DateSchedule, DateSchedule?)
		
		static func ==(lhs: TodayScheduleState, rhs: TodayScheduleState) -> Bool {
			switch (lhs, rhs) {
			case (.LOADING, .LOADING):
				return true
			case (.ERROR, .ERROR):
				return true
			case (.NULL, .NULL):
				return true
			case (let .NO_CLASS(todayA), let .NO_CLASS(todayB)):
				return todayA == todayB
			case (let .BEFORE_SCHOOL(todayA, nextA, timeA), let .BEFORE_SCHOOL(todayB, nextB, timeB)):
				return todayA == todayB && nextA == nextB && timeA == timeB
			case (let .BETWEEN_CLASS(todayA, curA, timeA), let .BETWEEN_CLASS(todayB, curB, timeB)):
				return todayA == todayB && curA == curB && timeA == timeB
			case (let .IN_CLASS(todayA, curA, nextA, timeA), let .IN_CLASS(todayB, curB, nextB, timeB)):
				return todayA == todayB && curA == curB && timeA == timeB && nextA == nextB
			case (let .AFTER_SCHOOL(todayA, scheduleA), let .AFTER_SCHOOL(todayB, scheduleB)):
				return todayA == todayB && scheduleA == scheduleB
			default:
				return false
			}
		}
		
	}
	
	static let instance = TodayManager()
	
	private var timer: Timer?
	
	private(set) var today: Date { didSet { self.tomorrow = self.today.dayInRelation(offset: 1) } }
	private(set) var tomorrow: Date
	
	private(set) var todaySchedule: DateSchedule?
	private(set) var fetchError: Error?
	
	private(set) var tomorrowSchedule: DateSchedule?
	
	let statusWatcher = ResourceWatcher<TodayScheduleState>()
	private(set) var currentState: TodayScheduleState = .LOADING
	
	init() {
		self.today = Date.today
		self.tomorrow = self.today.dayInRelation(offset: 1)

		super.init("Today")

		self.registerListeners()
		self.startTimer()
		
		ScheduleManager.instance.loadSchedule(date: self.today)
	}
	
	private func registerListeners() {
//		Today
		let localToday = self.today
		ScheduleManager.instance.getPatchWatcher(date: self.today).onSuccess(self) {
			schedule in
			
			if localToday.webSafeDate != self.today.webSafeDate {
				return
			}
			
			self.todaySchedule = schedule
			self.fetchError = nil
			
			self.updateState(state: self.getState())
		}
		
		ScheduleManager.instance.getPatchWatcher(date: self.today).onFailure(self) {
			error in

			if localToday.webSafeDate != self.today.webSafeDate {
				return
			}
			
			self.todaySchedule = nil
			self.fetchError = error
			
			self.updateState(state: self.getState())
		}
		
//		Tomorrow
		let localTomorrow = self.tomorrow
		ScheduleManager.instance.getPatchWatcher(date: self.tomorrow).onSuccess(self) {
			schedule in
			
			if localTomorrow.webSafeDate != self.tomorrow.webSafeDate { // Safety precaution to make sure we don't accidentally set the wrong things.
				return
			}
			
			self.tomorrowSchedule = schedule
			self.updateState(state: self.getState())
		}
		
		ScheduleManager.instance.getPatchWatcher(date: self.tomorrow).onSuccess(self) {
			error in
			
			if localTomorrow.webSafeDate != self.tomorrow.webSafeDate { // Safety precaution to make sure we don't accidentally set the wrong things.
				return
			}
			
			self.tomorrowSchedule = nil
			self.updateState(state: self.getState())
		}
	}
	
	private func unregisterListeners() {
		ScheduleManager.instance.getPatchWatcher(date: self.today).unregisterSuccess(self)
		ScheduleManager.instance.getPatchWatcher(date: self.today).unregisterFailure(self)
		
		ScheduleManager.instance.getPatchWatcher(date: self.tomorrow).unregisterSuccess(self)
		ScheduleManager.instance.getPatchWatcher(date: self.tomorrow).unregisterFailure(self)
	}
	
	func startTimer() {
		self.timer = Timer(timeInterval: 10.0, repeats: true, block: { timer in self.doUpdate() })
	}
	
	func stopTimer() {
		if self.timer != nil { self.timer!.invalidate() }
	}
	
	private func doUpdate() {
		let state = self.getState()
		switch state {
		case .AFTER_SCHOOL(_):
			self.updateOutsideDayContext(state: state)
			break
		default:
			self.updateWithinDayContext(state: state)
			break
		}
	}
	
	private func updateWithinDayContext(state: TodayScheduleState) {
		self.updateState(state: state)
	}
	
	private func updateOutsideDayContext(state: TodayScheduleState) {
		let now = Date.today
		if now.webSafeDate == self.today.webSafeDate { // If today and the context are the same, we don't have to update everything in the manager, but we have to load tomorrow's schedule and feed it to the handler.
			if self.tomorrowSchedule == nil {
				ScheduleManager.instance.loadSchedule(date: self.tomorrow)
			}
			self.updateState(state: state)
		} else { // Not today i.e. it's past midnight.
			self.unregisterListeners() // Unregister listeners for previous day
			self.today = now
			self.registerListeners() // Register listeners for today
			
			self.tomorrowSchedule = nil
			self.todaySchedule = nil
			self.fetchError = nil
			
			self.updateState(state: .LOADING)
			
			ScheduleManager.instance.loadSchedule(date: self.today)
		}
	}
	
	private func updateState(state: TodayScheduleState, watcher: Bool = true) {
		let previousState = self.currentState
		self.currentState = state
		
		if watcher && previousState != state {
			self.statusWatcher.handle(nil, state)
		}
	}
	
	func getCurrentBlock() -> Block? {
		if self.todaySchedule == nil {
			return nil
		}
		
		let current = Date()
		let schedule = self.todaySchedule!
		
		for block in schedule.getBlocks() {
			if block.time.contains(date: current) {
				return block
			}
		}
		return nil
	}
	
	func getNextBlock() -> Block? {
		guard let schedule = self.todaySchedule else {
			return nil
		}
		
		let now = Date.today
		
		for block in schedule.getBlocks() {
			if block.time.start < now { // Is already in progress or has passed
				continue
			}
			
			return block
		}
		return nil
	}
	
	func getState() -> TodayScheduleState {
		if self.fetchError != nil {
			return TodayScheduleState.ERROR
		}
		
		guard let schedule = self.todaySchedule else {
			return TodayScheduleState.NULL
		}
		
		if schedule.getBlocks().isEmpty {
			return TodayScheduleState.NO_CLASS(schedule)
		}
		
		let now = Date.today
		if now < schedule.getFirstBlock()!.time.start { // Before school
			let minUntilStart = abs(schedule.getFirstBlock()!.time.start.minuteDifference(date: now))
			return TodayScheduleState.BEFORE_SCHOOL(schedule, schedule.getFirstBlock()!, minUntilStart)
		}
		
		if now > schedule.getLastBlock()!.time.end { // After school
			return TodayScheduleState.AFTER_SCHOOL(schedule, self.tomorrowSchedule)
		}
		
		if let currentBlock = self.getCurrentBlock() { // In class
			let minLeft = abs(currentBlock.time.start.minuteDifference(date: now))
			let nextBlock = schedule.getBlockAfter(currentBlock)
			return TodayScheduleState.IN_CLASS(schedule, currentBlock, nextBlock, minLeft)
		} else { // Not in class
			let nextBlock = self.getNextBlock()!
			let minTo = abs(nextBlock.time.start.minuteDifference(date: now))
			return TodayScheduleState.BETWEEN_CLASS(schedule, nextBlock, minTo)
		}
	}
	
}
