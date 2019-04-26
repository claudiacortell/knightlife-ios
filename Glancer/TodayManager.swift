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
	
	public enum TodayScheduleState: Equatable {
		
		case LOADING
		case ERROR
		
		case NO_CLASS(DayBundle, DayBundle?)
		
		case BEFORE_SCHOOL(DayBundle, Block, Int)
		
		case BEFORE_SCHOOL_GET_TO_CLASS(DayBundle, Block, Int)
		case BETWEEN_CLASS(DayBundle, Block, Int)
		case IN_CLASS(DayBundle, Block, Block?, Int)
		
		case AFTER_SCHOOL(DayBundle, DayBundle?)
		
		static func ==(lhs: TodayScheduleState, rhs: TodayScheduleState) -> Bool {
			switch (lhs, rhs) {
			case (.LOADING, .LOADING):
				return true
			case (.ERROR, .ERROR):
				return true
			case (let .NO_CLASS(todayA, tomorrowA), let .NO_CLASS(todayB, tomorrowB)):
				return todayA == todayB && tomorrowA == tomorrowB
			case (let .BEFORE_SCHOOL(todayA, nextA, timeA), let .BEFORE_SCHOOL(todayB, nextB, timeB)):
				return todayA == todayB && nextA == nextB && timeA == timeB
			case (let .BEFORE_SCHOOL_GET_TO_CLASS(bundleA, blockA, timeA), let .BEFORE_SCHOOL_GET_TO_CLASS(bundleB, blockB, timeB)):
				return bundleA == bundleB && blockA == blockB && timeA == timeB
			case (let .BETWEEN_CLASS(todayA, curA, timeA), let .BETWEEN_CLASS(todayB, curB, timeB)):
				return todayA == todayB && curA == curB && timeA == timeB
			case (let .IN_CLASS(todayA, curA, nextA, timeA), let .IN_CLASS(todayB, curB, nextB, timeB)):
				return todayA == todayB && curA == curB && timeA == timeB && nextA == nextB
			case (let .AFTER_SCHOOL(todayA, tomorrowA), let .AFTER_SCHOOL(todayB, tomorrowB)):
				return todayA == todayB && tomorrowA == tomorrowB
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
	private(set) var findingNextDay: Bool = false
	
	let statusWatcher = ResourceWatcher<TodayScheduleState>()
	private(set) var currentState: TodayScheduleState = .LOADING
	
	let nextDayWatcher = ResourceWatcher<Date>() // Fires off when it's the next day.
	
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
	
	func reloadNextDayBundle() {
		self.nextDayBundle = nil
		self.nextDayError = nil
		
		guard let nextDay = self.nextDay else {
			return
		}
		
		DayBundleManager.instance.getDayBundle(date: nextDay)
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
		
		Schedule.onFirstLunchChange.subscribe(with: self) { change in
			
			self.updateState(state: self.getState(), force: true)
			
		}.filter({ $0.dayOfWeek == self.today.weekday })
	}
	
	private func registerNextDayListeners() {
		guard let localNextDay = self.nextDay else {
			return
		}
		
		DayBundleManager.instance.getBundleWatcher(date: localNextDay).onSuccess(self) {
			bundle in
			
			guard let nextDay = self.nextDay else {
				return
			}
			
			if localNextDay.webSafeDate != nextDay.webSafeDate {
				return
			}
			
			self.nextDayBundle = bundle
			self.nextDayError = nil
			
			self.updateState(state: self.getState())
		}
		
		DayBundleManager.instance.getBundleWatcher(date: localNextDay).onFailure(self) {
			error in
			
			guard let nextDay = self.nextDay else {
				return
			}
			
			if localNextDay.webSafeDate != nextDay.webSafeDate {
				return
			}
			
			self.nextDayBundle = nil
			self.nextDayError = error
			
			self.updateState(state: self.getState())
		}
		
		Schedule.onFirstLunchChange.subscribe(with: self) { change in
			
			self.updateState(state: self.getState(), force: true)
			
		}.filter({ $0.dayOfWeek == localNextDay.weekday })
	}
	
	private func unregisterListeners() {
		DayBundleManager.instance.getBundleWatcher(date: self.today).unregisterSuccess(self)
		DayBundleManager.instance.getBundleWatcher(date: self.today).unregisterFailure(self)
		
		if let nextDay = self.nextDay {
			DayBundleManager.instance.getBundleWatcher(date: nextDay).unregisterSuccess(self)
			DayBundleManager.instance.getBundleWatcher(date: nextDay).unregisterFailure(self)
		}
		
		Schedule.onFirstLunchChange.cancelSubscription(for: self)
	}
	
	func startTimer() {
		if self.timer != nil {
			return
		}
		
		self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
			timer in
			self.doUpdate()
		}
		
		self.timer!.fire() // Fire immediately without waiting a second.
	}
	
	func stopTimer() {
		if self.timer != nil { self.timer!.invalidate() ; self.timer = nil }
	}
	
	private func doUpdate() {
		let state = self.getState()
		
		switch state {
		case .AFTER_SCHOOL(_):
			self.updateOutsideDayContext(state: state)
			break
		case .NO_CLASS(_, _):
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
			self.findingNextDay = false
			
			self.reloadTodayBundle()
			
			self.nextDayWatcher.handle(nil, self.today)
		} else {
			if self.nextDay == nil && !self.findingNextDay {
				self.findingNextDay = true
				
				let localToday = self.today
				NextSchooldayWebCall(today: self.today).callback() {
					result in
					
					if localToday.webSafeDate != self.today.webSafeDate { // Make sure the web call didn't execute in the previous day
						return
					}
					
					var date: Date?
					var error: Error?
					
					switch result {
					case let .success(result):
						date = result
					case let .failure(problem):
						error = problem
					}
					
					self.nextDay = date
					self.nextDayError = error
					
					self.findingNextDay = false
					
					if self.nextDay != nil {
						self.registerNextDayListeners()
						self.reloadNextDayBundle()
					}
				}.execute()
			}

			self.updateState(state: state)
		}
	}
	
	private func updateState(state: TodayScheduleState, watcher: Bool = true, force: Bool = false) {
		let previousState = self.currentState
		self.currentState = state
		
		if watcher {
			if force || previousState != state {
				self.statusWatcher.handle(nil, state)
			} else {
				switch state {
				case .IN_CLASS(_, _, _, _): // Always update in class so the loading bar can update every second.
					self.statusWatcher.handle(nil, state)
				default:
					break
				}
			}
		}
	}
	
	func getCurrentBlock() -> Block? {
		guard let bundle = self.todayBundle else {
			return nil
		}
		
		let current = Date()
		if let timetable = bundle.schedule.selectedTimetable {
			for block in timetable.filterBlocksByLunch() {
				if block.time.contains(date: current) {
					return block
				}
			}

		}
		return nil
	}
	
	func getNextBlock() -> Block? {
		guard let bundle = self.todayBundle else {
			return nil
		}
		
		let now = Date.today
		
		if let timetable = bundle.schedule.selectedTimetable {
			for block in timetable.filterBlocksByLunch() {
				if block.time.start < now { // Is already in progress or has passed
					continue
				}
				
				return block
			}
		}
		
		return nil
	}
	
	func getState() -> TodayScheduleState {
		if self.todayError == nil && self.todayBundle == nil {
			return TodayScheduleState.LOADING
		}
		
		if let _ = self.todayError {
			return TodayScheduleState.ERROR
		}
		
		let bundle = self.todayBundle!
		let schedule = bundle.schedule
		
		if !schedule.hasSchool {
			return TodayScheduleState.NO_CLASS(bundle, self.nextDayBundle)
		}
		
		let timetable = schedule.selectedTimetable!
		
		let now = Date.today
		if now < timetable.firstBlock!.time.start { // Before school
			var minUntilStart = abs(timetable.firstBlock!.time.start.minuteDifference(date: now))
			minUntilStart += 1
			
			if minUntilStart <= 5 {
				return TodayScheduleState.BEFORE_SCHOOL_GET_TO_CLASS(bundle, timetable.firstBlock!, minUntilStart)
			}
			
			return TodayScheduleState.BEFORE_SCHOOL(bundle, timetable.firstBlock!, minUntilStart)
		}
		
		if now > timetable.lastBlock!.time.end { // After school
			return TodayScheduleState.AFTER_SCHOOL(bundle, self.nextDayBundle)
		}
		
		if let currentBlock = self.getCurrentBlock() { // In class
			var minLeft = abs(currentBlock.time.end.minuteDifference(date: now))
			minLeft += 1
			let nextBlock = timetable.getBlockAfter(block: currentBlock)
			return TodayScheduleState.IN_CLASS(bundle, currentBlock, nextBlock, minLeft)
		} else { // Not in class
			let nextBlock = self.getNextBlock()!
			var minTo = abs(nextBlock.time.start.minuteDifference(date: now))
			minTo += 1
			return TodayScheduleState.BETWEEN_CLASS(bundle, nextBlock, minTo)
		}
	}
	
}
