//
//  ScheduleManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

class SchedulePushListener: PushRefreshListener {
	
	var refreshListenerType: [PushRefreshType] = [.SCHEDULE]
	
	func doListenerRefresh(date: Date, queue: DispatchGroup) {
		queue.enter()
		
		Schedule.fetch(for: date).subscribeOnce(with: self) {
			switch $0 {
			case .success(let schedule):
				Schedule.onFetch.fire(schedule)
			case .failure(_):
				break
			}
			
			queue.leave()
		}
	}
	
}

//class ScheduleManager: Manager, PushRefreshListener {
//
//	static let instance = ScheduleManager()
//
//	let refreshListenerType: [PushRefreshType] = [.SCHEDULE] // Only listener to Schedule refresh requests.
//
//	let defaultVariation = 0
//	private(set) var scheduleVariations: [DayOfWeek: Int] = [:]
//	private(set) var scheduleVariationWatchers: [DayOfWeek: ResourceWatcher<Int>] = [:]
//	private(set) var scheduleVariationUpdatedWatcher = ResourceWatcher<(DayOfWeek, Int)>()
//
//	private(set) var template: [DayOfWeek: DaySchedule]?
//	let templateWatcher: ResourceWatcher<[DayOfWeek: DaySchedule]> = ResourceWatcher<[DayOfWeek: DaySchedule]>()
//	var templateLoaded: Bool { return self.template != nil }
//
//	private(set) var patches: [String: Schedule] = [:]
//	private var patchWatchers: [String: ResourceWatcher<Schedule>] = [:]
//
//	init() {
//		super.init("Schedule")
//
//		PushNotificationManager.instance.addListener(type: .REFRESH, listener: self)
//		self.registerStorage(ScheduleVariationStorage(manager: self))
//
//		self.loadTemplate()
//	}
//
//	func clearCache() {
//		self.patches.removeAll()
//	}
//
//	func getVariationWatcher(day: DayOfWeek) -> ResourceWatcher<Int> {
//		if self.scheduleVariationWatchers[day] == nil {
//			self.scheduleVariationWatchers[day] = ResourceWatcher<Int>()
//		}
//		return self.scheduleVariationWatchers[day]!
//	}
//
//	func getCachedPatch(date: Date) -> Schedule? {
//		return self.patches[date.webSafeDate]
//	}
//
//	func getPatchWatcher(date: Date) -> ResourceWatcher<Schedule> {
//		if self.patchWatchers[date.webSafeDate] == nil {
//			self.patchWatchers[date.webSafeDate] = ResourceWatcher<Schedule>()
//		}
//		return self.patchWatchers[date.webSafeDate]!
//	}
//
//	func loadedVariation(day: DayOfWeek, variation: Int) {
//		self.scheduleVariations[day] = variation
//	}
//
//	func setVariation(day: DayOfWeek, variation: Int) {
//		self.scheduleVariations[day] = variation
//		self.saveStorage()
//
//		self.getVariationWatcher(day: day).handle(nil, variation)
//
//		self.scheduleVariationUpdatedWatcher.handle(nil, (day, variation))
//	}
//
//	func getVariation(_ day: DayOfWeek) -> Int {
//		return self.scheduleVariations[day] ?? self.defaultVariation
//	}
//
//	func getVariation(_ date: Date) -> Int {
//		return self.scheduleVariations[date.weekday] ?? self.defaultVariation
//	}
//
//	func loadTemplate() {
//		if self.template != nil {
//			return // template needs only be loaded once.
//		}
//
//		GetScheduleWebCall().callback() {
//			result in
//
//			switch result {
//			case .success(let template):
//				self.template = template
//				self.templateWatcher.handle(nil, template)
//			case .failure(let error):
//				self.template = nil
//				self.templateWatcher.handle(error, nil)
//			}
//
//		}.execute()
//	}
//
//	func doListenerRefresh(date: Date, queue: DispatchGroup) {
//		queue.enter()
//
//		self.loadSchedule(date: date, force: true) {
//			_ in
//
//			queue.leave()
//		}
//	}
//
//	func loadSchedule(date: Date, force: Bool = false, then: @escaping (WebCallResult<Schedule>) -> Void = {_ in}) {
//		if !force, let patch = self.getCachedPatch(date: date) {
//			then(WebCallResult.success(result: patch))
//			return
//		}
//
//		GetPatchWebCall(date: date).callback() {
//			result in
//
//			var schedule: Schedule?
//			var error: Error?
//
//			switch result {
//			case .success(let item):
//				schedule = item
//				break
//			case .failure(let fail):
//				error = fail
//				break
//			}
//
//			self.patches[date.webSafeDate] = schedule
//			self.getPatchWatcher(date: date).handle(error, schedule)
//
//			then(result)
//		}.execute()
//	}
//
//}
