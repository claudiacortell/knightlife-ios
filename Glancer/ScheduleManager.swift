//
//  ScheduleManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

class ScheduleManager: Manager {
	
	static let instance = ScheduleManager()
	
	private(set) var scheduleVariations: [DayOfWeek: Int] = [:]
	
	private(set) var template: [DayOfWeek: DaySchedule]?
	let templateWatcher: ResourceWatcher<[DayOfWeek: DaySchedule]> = ResourceWatcher<[DayOfWeek: DaySchedule]>()
	var templateLoaded: Bool { return self.template != nil }
	
	private(set) var patches: [String: DateSchedule] = [:]
	private var patchWatchers: [String: ResourceWatcher<DateSchedule>] = [:]
	
	init() {
		super.init("Schedule")

		self.registerStorage(ScheduleVariationStorage(manager: self))
		
		self.loadTemplate()
	}
	
	func getPatchWatcher(date: Date) -> ResourceWatcher<DateSchedule> {
		if self.patchWatchers[date.webSafeDate] == nil {
			self.patchWatchers[date.webSafeDate] = ResourceWatcher<DateSchedule>()
		}
		return self.patchWatchers[date.webSafeDate]!
	}
	
	func loadedVariation(day: DayOfWeek, variation: Int) {
		self.scheduleVariations[day] = variation
	}
	
	func setVariation(day: DayOfWeek, variation: Int) {
		self.scheduleVariations[day] = variation
		self.saveStorage()
	}
	
	func getVariation(_ day: DayOfWeek) -> Int {
		return self.scheduleVariations[day] ?? 0
	}
	
	func getVariation(_ date: Date) -> Int {
		return self.scheduleVariations[date.weekday] ?? 0
	}
	
	func loadTemplate() {
		if self.template != nil {
			return // template needs only be loaded once.
		}
		
		GetScheduleWebCall().callback() {
			result in
			
			switch result {
			case .success(let template):
				self.template = template
				self.templateWatcher.handle(nil, template)
			case .failure(let error):
				self.template = nil
				self.templateWatcher.handle(error, nil)
			}
			
		}.execute()
	}
	
	func loadSchedule(date: Date) {
		GetPatchWebCall(date: date).callback() {
			result in
			
			var schedule: DateSchedule?
			var error: Error?
			
			switch result {
			case .success(let item):
				schedule = item
				break
			case .failure(let fail):
				error = fail
				break
			}
			
			self.patches[date.webSafeDate] = schedule
			self.getPatchWatcher(date: date).handle(error, schedule)
		}.execute()
	}
	
}
