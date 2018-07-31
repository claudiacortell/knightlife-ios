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
		
		case NO_CLASS(DayBundle)
		
		case BEFORE_SCHOOL(DayBundle, Block, Int)
		case BETWEEN_CLASS(DayBundle, Block, Int)
		case IN_CLASS(DayBundle, Block, Block?, Int)
		
		case AFTER_SCHOOL(DayBundle)
		
		static func ==(lhs: TodayScheduleState, rhs: TodayScheduleState) -> Bool {
			switch (lhs, rhs) {
			case (.LOADING, .LOADING):
				return true
			case (.ERROR, .ERROR):
				return true
			case (let .NO_CLASS(todayA), let .NO_CLASS(todayB)):
				return todayA == todayB
			case (let .BEFORE_SCHOOL(todayA, nextA, timeA), let .BEFORE_SCHOOL(todayB, nextB, timeB)):
				return todayA == todayB && nextA == nextB && timeA == timeB
			case (let .BETWEEN_CLASS(todayA, curA, timeA), let .BETWEEN_CLASS(todayB, curB, timeB)):
				return todayA == todayB && curA == curB && timeA == timeB
			case (let .IN_CLASS(todayA, curA, nextA, timeA), let .IN_CLASS(todayB, curB, nextB, timeB)):
				return todayA == todayB && curA == curB && timeA == timeB && nextA == nextB
			case (let .AFTER_SCHOOL(todayA), let .AFTER_SCHOOL(todayB)):
				return todayA == todayB
			default:
				return false
			}
		}
		
	}
	
	static let instance = TodayManager()
	private var timer: Timer?
	
	private(set) var today: Date
	private(set) var todayBundle: DayBundle?
	private(set) var todayError: Error?
	
	private(set) var nextDay: Date?
	private(set) var nextDayBundle: DayBundle?
	private(set) var nextDayError: Error?
	
	let statusWatcher = ResourceWatcher<TodayScheduleState>()
	private(set) var currentState: TodayScheduleState = .LOADING
	
	init() {
		self.today = Date.today

		super.init("Today")

		self.registerListeners()
		self.startTimer()
		
		self.reloadTodayBundle()
	}
	
	func reloadTodayBundle(then: @escaping (Bool) -> Void = {_ in}) {
		self.todayBundle = nil
		self.todayError = nil
		
		self.updateState(state: self.getState())
		DayBundleManager.instance.getDayBundle(date: self.today, then: then)
	}
	
	private func registerListeners() {
//		Today
		let localToday = self.today
		DayBundleManager.instance.getBundleWatcher(date: self.today).onSuccess(self) {
			bundle in
			
			if localToday.webSafeDate != self.today.webSafeDate {
				return
			}
			
			self.todayBundle = bundle
			self.todayError = nil
			
			self.updateState(state: self.getState())
		}
		
		DayBundleManager.instance.getBundleWatcher(date: self.today).onFailure(self) {
			error in
			
			if localToday.webSafeDate != self.today.webSafeDate {
				return
			}
			
			self.todayBundle = nil
			self.todayError = error
			
			self.updateState(state: self.getState())
		}
	}
	
	private func unregisterListeners() {
		DayBundleManager.instance.getBundleWatcher(date: self.today).unregisterSuccess(self)
		DayBundleManager.instance.getBundleWatcher(date: self.today).unregisterFailure(self)
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
		if now.webSafeDate != self.today.webSafeDate { // If the loaded Date isn't the current date, we load tomorrow's schedule
			self.unregisterListeners()
			self.today = now
			self.registerListeners()
			
			self.updateState(state: .LOADING)
			
			self.nextDay = nil
			self.nextDayBundle = nil
			self.nextDayError = nil
			
			self.reloadTodayBundle()
		} else {
			if self.nextDay == nil {
				self.nextDay = self.today.dayInRelation(offset: 1)
				let chain = ProcessChain()
				
			}
			
			self.updateState(state: state)
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
		guard let bundle = self.todayBundle else {
			return nil
		}
		
		let current = Date()
		for block in bundle.schedule.getBlocks() {
			if block.time.contains(date: current) {
				return block
			}
		}
		return nil
	}
	
	func getNextBlock() -> Block? {
		guard let bundle = self.todayBundle else {
			return nil
		}
		
		let now = Date.today
		
		for block in bundle.schedule.getBlocks() {
			if block.time.start < now { // Is already in progress or has passed
				continue
			}
			
			return block
		}
		return nil
	}
	
	func getState() -> TodayScheduleState {
		if self.todayError == nil && self.todayBundle == nil {
			return TodayScheduleState.LOADING
		}
		
		if let error = self.todayError {
			return TodayScheduleState.ERROR
		}
		
		let bundle = self.todayBundle!
		let schedule = bundle.schedule
		
		if schedule.getBlocks().isEmpty {
			return TodayScheduleState.NO_CLASS(bundle)
		}
		
		let now = Date.today
		if now < schedule.getFirstBlock()!.time.start { // Before school
			let minUntilStart = abs(schedule.getFirstBlock()!.time.start.minuteDifference(date: now))
			return TodayScheduleState.BEFORE_SCHOOL(bundle, schedule.getFirstBlock()!, minUntilStart)
		}
		
		if now > schedule.getLastBlock()!.time.end { // After school
			return TodayScheduleState.AFTER_SCHOOL(bundle)
		}
		
		if let currentBlock = self.getCurrentBlock() { // In class
			let minLeft = abs(currentBlock.time.start.minuteDifference(date: now))
			let nextBlock = schedule.getBlockAfter(currentBlock)
			return TodayScheduleState.IN_CLASS(bundle, currentBlock, nextBlock, minLeft)
		} else { // Not in class
			let nextBlock = self.getNextBlock()!
			let minTo = abs(nextBlock.time.start.minuteDifference(date: now))
			return TodayScheduleState.BETWEEN_CLASS(bundle, nextBlock, minTo)
		}
	}
	
}
