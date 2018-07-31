//
//  DayBundleManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/28/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class DayBundleManager: Manager {
	
	static let instance = DayBundleManager()
	
	private var bundleWatcher: [String: ResourceWatcher<DayBundle>] = [:]
	
	init() {
		super.init("Bundle")
		
		self.registerListeners()
	}
	
	func registerListeners() {
		//		TODO: Make the bundles auto updating without causing an infinite loop.
	}
	
	func getBundleWatcher(date: Date) -> ResourceWatcher<DayBundle> {
		if self.bundleWatcher[date.webSafeDate] == nil {
			self.bundleWatcher[date.webSafeDate] = ResourceWatcher<DayBundle>()
		}
		return self.bundleWatcher[date.webSafeDate]!
	}
	
	func getDayBundle(date: Date, then: @escaping (Bool) -> Void = {_ in}) {
		ProcessChain().link() {
			chain in
			
			ScheduleManager.instance.loadSchedule(date: date) {
				result in
				
				switch result {
				case .success(let schedule):
					chain.setData("schedule", data: schedule)
					chain.next()
				case .failure(let error):
					chain.setData("error", data: error)
					chain.next(false)
				}
			}
		}.link() {
			chain in
			
			EventManager.instance.getEvents(date: date) {
				result in
				
				switch result {
				case .success(let events):
					chain.setData("events", data: events)
					chain.next()
				case .failure(let error):
					chain.setData("error", data: error)
					chain.next(false)
				}
			}
		}.link() {
			chain in
			
			LunchManager.instance.fetchLunchMenu(date: date) {
				result in
				
				switch result {
				case .success(let lunch):
					chain.setData("lunch", data: lunch)
					chain.next()
				case .failure(let error):
					chain.setData("error", data: error)
					chain.next(false)
				}
			}
		}.success() {
			chain in
			
			let bundle = DayBundle(date: date, schedule: chain.getData("schedule")!, events: chain.getData("events")!, menu: chain.getData("lunch")!)
			self.getBundleWatcher(date: date).handle(nil, bundle)
			
			then(true)
		}.failure() {
			chain in
			self.getBundleWatcher(date: date).handle(chain.getData("error"), nil)
			
			then(false)
		}.start()
	}
	
}
