//
//  TodayManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 6/3/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Signals
import Moya
import SwiftyJSON
import Timepiece

extension TodayManager {
	
	public enum ScheduleState {
		
		case LOADING
		case ERROR
		
		case NO_CLASS( Day,  Day?)
		
		case BEFORE_SCHOOL( Day, Block, Int)
		
		case BEFORE_SCHOOL_GET_TO_CLASS( Day, Block, Int)
		case BETWEEN_CLASS( Day, Block, Int)
		case IN_CLASS( Day, Block, Block?, Int)
		
		case AFTER_SCHOOL( Day,  Day?)
		
	}
	
}

extension TodayManager.ScheduleState: Equatable {
	
	static func ==(lhs: TodayManager.ScheduleState, rhs: TodayManager.ScheduleState) -> Bool {
		switch (lhs, rhs) {
		case (.LOADING, .LOADING):
			return true
		case (.ERROR, .ERROR):
			return true
		case (let .NO_CLASS(todayA, tomorrowA), let .NO_CLASS(todayB, tomorrowB)):
			return todayA === todayB && tomorrowA === tomorrowB
		case (let .BEFORE_SCHOOL(todayA, nextA, timeA), let .BEFORE_SCHOOL(todayB, nextB, timeB)):
			return todayA === todayB && nextA == nextB && timeA == timeB
		case (let .BEFORE_SCHOOL_GET_TO_CLASS(bundleA, blockA, timeA), let .BEFORE_SCHOOL_GET_TO_CLASS(bundleB, blockB, timeB)):
			return bundleA === bundleB && blockA == blockB && timeA == timeB
		case (let .BETWEEN_CLASS(todayA, curA, timeA), let .BETWEEN_CLASS(todayB, curB, timeB)):
			return todayA === todayB && curA == curB && timeA == timeB
		case (let .IN_CLASS(todayA, curA, nextA, timeA), let .IN_CLASS(todayB, curB, nextB, timeB)):
			return todayA === todayB && curA == curB && timeA == timeB && nextA == nextB
		case (let .AFTER_SCHOOL(todayA, tomorrowA), let .AFTER_SCHOOL(todayB, tomorrowB)):
			return todayA === todayB && tomorrowA === tomorrowB
		default:
			return false
		}
	}
	
}

private(set) var TodayM: TodayManager! = TodayManager()

final class TodayManager {
	
	private var timer: Timer?
	
	private(set) var todayDate: Date
	let todayUpdater: CallbackSignal< Day> = CallbackSignal< Day>(retainLastData: true)
	
	private(set) var nextDayDate: Date?
	let nextDayUpdater: CallbackSignal< Day> = CallbackSignal< Day>(retainLastData: true)
	private var fetchingNextDay = false
	
	let onNextDay = Signal<Date>()
	
	let onStateChange = Signal<ScheduleState>()
	private(set) var state: ScheduleState = .LOADING {
		didSet {
			// Trigger signal if state is actually changed
			if oldValue != self.state {
				self.onStateChange.fire(self.state)
			}
		}
	}
	
	fileprivate init() {
		self.todayDate = Date.today
		
		self.registerListeners()
		self.fetchTodayBundle()
	}
	
	func registerListeners() {
		// When Today's bundle is fetched
		self.todayUpdater.subscribe(with: self) {
			switch $0 {
			case .success(let bundle):
				// If we successfully fetched a new Bundle, we listen to any updates that occur with it, then update the Manager accordingly. Or, if that bundle is no longer the bundle we want to listen to, we cancel our subscription. This'll protect us in the event that we pass midnight and the current Bundle changes.
				bundle.onUpdate.subscribe(with: self) { bundle in
					if bundle == self.todayBundle {
						self.update()
					} else {
						bundle.onUpdate.cancelSubscription(for: self)
					}
				}
				
				// Listen to when the Bundle's schedule updates its first/second lunch
				bundle.schedule.onFirstLunchUpdate.subscribe(with: self) { _ in
					if bundle == self.todayBundle {
						self.update()
					} else {
						bundle.schedule.onFirstLunchUpdate.cancelSubscription(for: self)
					}
				}
				
				// Listen when the Bundle's seleected timetable changes
				bundle.schedule.onSelectedTimetableChange.subscribe(with: self) { _ in
					if bundle == self.todayBundle {
						self.update()
					} else {
						bundle.schedule.onSelectedTimetableChange.cancelSubscription(for: self)
					}
				}
			default:
				break
			}
			
			self.update()
		}
		
		// When the Next Day's bundle is fetched
		self.nextDayUpdater.subscribe(with: self) {
			switch $0 {
			case .success(let bundle):
				bundle.onUpdate.subscribe(with: self) { bundle in
					if bundle == self.nextDayBundle {
						self.update()
					} else {
						bundle.onUpdate.cancelSubscription(for: self)
					}
				}
				
				bundle.schedule.onFirstLunchUpdate.subscribe(with: self) { _ in
					if bundle == self.nextDayBundle {
						self.update()
					} else {
						bundle.schedule.onFirstLunchUpdate.cancelSubscription(for: self)
					}
				}
				
				bundle.schedule.onSelectedTimetableChange.subscribe(with: self) { _ in
					if bundle == self.todayBundle {
						self.update()
					} else {
						bundle.schedule.onSelectedTimetableChange.cancelSubscription(for: self)
					}
				}
			default:
				break
			}
			
			self.update()
		}
	}
	
	private var todayBundle: Day? {
		if let lastData = self.todayUpdater.lastDataFired {
			switch lastData {
			case .success(let bundle):
				return bundle
			default:
				return nil
			}
		}
		return nil
	}
	
	private var nextDayBundle: Day? {
		if let lastData = self.nextDayUpdater.lastDataFired {
			switch lastData {
			case .success(let bundle):
				return bundle
			default:
				return nil
			}
		}
		return nil
	}
	
	@discardableResult
	func fetchTodayBundle() -> CallbackSignal<Day> {
		let signal = Day.fetch(for: self.todayDate)
		
		signal.subscribeOnce(with: self) {
			self.todayUpdater.fire($0)
		}
		
		return signal
	}
	
	@discardableResult
	func fetchNextDayBundle() -> CallbackSignal<Day> {
		if let nextDayDate = self.nextDayDate {
			let signal = Day.fetch(for: nextDayDate)
			
			signal.subscribeOnce(with: self) {
				self.nextDayUpdater.fire($0)
			}
			
			return signal
		}
		
		// If no date, return an empty callback
		return CallbackSignal<Day>()
	}
	
	func startTimer() {
		if let _ = self.timer {
			return
		}
		
		self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			self.update()
		}
		
		self.timer!.fire()
	}
	
	func stopTimer() {
		if let timer = self.timer {
			timer.invalidate()
			self.timer = nil
		}
	}
	
	private func update() {
		let state = self.determineCurrentState()
		
		switch state {
		case .AFTER_SCHOOL(_):
			self.updateAfterSchool(state: state)
			break
		case .NO_CLASS(_, _):
			self.updateAfterSchool(state: state)
			break
		default:
			self.state = state
			break
		}
		
		self.onStateChange.fire(self.state)
	}
	
	private func updateAfterSchool(state: ScheduleState) {
		let now = Date.today
		
		// If the loaded Date isn't the current date, it's time to switch to the next day
		if now.webSafeDate != self.todayDate.webSafeDate {
			self.todayDate = now
			
			self.state = .LOADING
			
			// Reset stored Bundles
			self.todayUpdater.clearLastData()
			self.nextDayUpdater.clearLastData()
			
			self.onNextDay.fire(self.todayDate)
			
			self.fetchTodayBundle()
			
			return
		}
		
		// Otherwise, we load the next day's schedule
		if self.nextDayDate == nil && !self.fetchingNextDay {
			self.fetchingNextDay = true
			
			let provider = MoyaProvider<API>()
			provider.request(.getWeekBundles) {
				switch $0 {
				case .success(let res):
					do {
						_ = try res.filterSuccessfulStatusCodes()
						
						let data = res.data
						let json = try JSON(data: data)
						
						var bundles = try json.dictionaryValue.values.compactMap({ try Day(json: $0) })
						
						// Sort bundles by date
						bundles.sort(by: { $0.date < $1.date })
						
						// Sort through the bundles, find one that has school, set that as the next day
						for bundle in bundles {
							// Ignore today's bundle
							if bundle.schedule.date.webSafeDate == Date.today().webSafeDate {
								continue
							}
							
							if bundle.schedule.hasSchool {
								self.nextDayDate = bundle.date
								self.nextDayUpdater.fire(.success(bundle))
								
								break
							}
						}
					} catch {
						self.nextDayUpdater.fire(.failure(error))
					}
				case .failure(let error):
					self.nextDayUpdater.fire(.failure(error))
				}
				
				self.fetchingNextDay = false
			}
		}
		
		// SEt the state
		self.state = state
	}
	
	var currentBlock: Block? {
		guard let bundle = self.todayBundle else {
			return nil
		}
		
		guard let timetable = bundle.schedule.selectedTimetable else {
			return nil
		}
		
		let now = Date()
		for block in timetable.filterBlocksByLunch() {
			if block.schedule.duration.contains(date: now) {
				return block
			}
		}
		
		return nil
	}
	
	var nextBlock: Block? {
		guard let bundle = self.todayBundle else {
			return nil
		}
		
		guard let timetable = bundle.schedule.selectedTimetable else {
			return nil
		}
		
		let now = Date()
		for block in timetable.filterBlocksByLunch() {
			if block.schedule.start < now { // Is already in progress or has passed already
				return block
			}
			
			return block
		}
		
		return nil
	}
	
	func determineCurrentState() -> ScheduleState {
		if self.todayUpdater.lastDataFired == nil {
			return ScheduleState.LOADING
		}
		
		guard let bundle = self.todayBundle else {
			return ScheduleState.ERROR
		}
		
		let schedule = bundle.schedule!
		
		if !schedule.hasSchool {
			return ScheduleState.NO_CLASS(bundle, self.nextDayBundle)
		}
		
		let timetable = schedule.selectedTimetable!
		
		let now = Date.today
		if now < timetable.firstBlock!.schedule.start { // Before school
			var minUntilStart = abs(timetable.firstBlock!.schedule.start.minuteDifference(date: now))
			minUntilStart += 1
			
			if minUntilStart <= 5 {
				return ScheduleState.BEFORE_SCHOOL_GET_TO_CLASS(bundle, timetable.firstBlock!, minUntilStart)
			}
			
			return ScheduleState.BEFORE_SCHOOL(bundle, timetable.firstBlock!, minUntilStart)
		}
		
		if now > timetable.lastBlock!.schedule.end { // After school
			return ScheduleState.AFTER_SCHOOL(bundle, self.nextDayBundle)
		}
		
		if let currentBlock = self.currentBlock { // In class
			var minLeft = abs(currentBlock.schedule.end.minuteDifference(date: now))
			minLeft += 1
			let nextBlock = timetable.getBlockAfter(block: currentBlock)
			return ScheduleState.IN_CLASS(bundle, currentBlock, nextBlock, minLeft)
		} else { // Not in class
			let nextBlock = self.nextBlock!
			var minTo = abs(nextBlock.schedule.start.minuteDifference(date: now))
			minTo += 1
			return ScheduleState.BETWEEN_CLASS(bundle, nextBlock, minTo)
		}
	}
	
}
