//
//  DayBundleManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/28/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import SwiftyJSON

class DayBundleManager: Manager {
	
	static let instance = DayBundleManager()
	
	private var bundleWatcher: [String: ResourceWatcher<DayBundle>] = [:]
	
	init() {
		super.init("Bundle")
	}
	
	private func registerListeners(date: Date) {
//		These just listen for new data from each of the three points, then reloads that date's respective bundle.
		
		Schedule.onFetch.subscribe(with: self) { schedule in
			//			Have Schedule, fetch lunch and events.
			//			Perform a chain to get the menu for each of the other ones, then update the corresponding watcher so that everything gets sent to everything else.
			ProcessChain().link() {
				chain in
				
				Lunch.fetch(for: date).subscribeOnce(with: self) {
					switch $0 {
					case .success(let lunch):
						chain.setData("menu", data: lunch)
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
						case .success(let result):
							chain.setData("events", data: result)
							chain.next()
						case .failure(let error):
							chain.setData("error", data: error)
							chain.next(false)
						}
					}
				}.success() {
					chain in
					
					let bundle = DayBundle(date: date, schedule: schedule, events: chain.getData("events")!, menu: chain.getData("menu")!)
					self.getBundleWatcher(date: date).handle(nil, bundle)
				}.failure() {
					chain in
					
					self.getBundleWatcher(date: date).handle(chain.getData("error"), nil)
				}.start()
		}
		
		Lunch.onFetch.subscribe(with: self) { menu in
			
//			Have Menu, fetch schedule and events.
//			Perform a chain to get the menu for each of the other ones, then update the corresponding watcher so that everything gets sent to everything else.
			ProcessChain().link() {
				chain in
				
				Schedule.fetch(for: date).subscribeOnce(with: self) {
					switch $0 {
					case .success(let result):
						chain.setData("schedule", data: result)
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
					case .success(let result):
						chain.setData("events", data: result)
						chain.next()
					case .failure(let error):
						chain.setData("error", data: error)
						chain.next(false)
					}
				}
			}.success() {
				chain in
				
				let bundle = DayBundle(date: date, schedule: chain.getData("schedule")!, events: chain.getData("events")!, menu: menu)
				self.getBundleWatcher(date: date).handle(nil, bundle)
			}.failure() {
				chain in
				
				self.getBundleWatcher(date: date).handle(chain.getData("error"), nil)
			}.start()
		}
		
		EventManager.instance.getEventWatcher(date: date).onSuccess(self) {
			events in
			
			//			Have Schedule, fetch lunch and events.
			//			Perform a chain to get the menu for each of the other ones, then update the corresponding watcher so that everything gets sent to everything else.
			ProcessChain().link() {
				chain in
				
				Lunch.fetch(for: date).subscribeOnce(with: self) {
					switch $0 {
					case .success(let result):
						chain.setData("menu", data: result)
						chain.next()
					case .failure(let error):
						chain.setData("error", data: error)
						chain.next(false)
					}
				}
			}.link() {
				chain in
				
				Schedule.fetch(for: date).subscribeOnce(with: self) {
					switch $0 {
					case .success(let result):
						chain.setData("schedule", data: result)
						chain.next()
					case .failure(let error):
						chain.setData("error", data: error)
						chain.next(false)
					}
				}
			}.success() {
				chain in
				
				let bundle = DayBundle(date: date, schedule: chain.getData("schedule")!, events: events, menu: chain.getData("menu")!)
				self.getBundleWatcher(date: date).handle(nil, bundle)
			}.failure() {
				chain in
				
				self.getBundleWatcher(date: date).handle(chain.getData("error"), nil)
			}.start()
		}
		
		EventManager.instance.getEventWatcher(date: date).onFailure(self) {
			error in
			
			self.getBundleWatcher(date: date).handle(error, nil)
		}
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
			
			Schedule.fetch(for: date).subscribeOnce(with: self) {
				switch $0 {
				case .success(let result):
					chain.setData("schedule", data: result)
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
			
			Lunch.fetch(for: date).subscribeOnce(with: self) {
				switch $0 {
				case .success(let result):
					chain.setData("menu", data: result)
					chain.next()
				case .failure(let error):
					chain.setData("error", data: error)
					chain.next(false)
				}
			}

		}.success() {
			chain in
			
			let bundle = DayBundle(date: date, schedule: chain.getData("schedule")!, events: chain.getData("events")!, menu: chain.getData("menu")!)
			self.getBundleWatcher(date: date).handle(nil, bundle)
			
			self.registerListeners(date: date)
			
			then(true)
		}.failure() {
			chain in
			
			let error: Error = chain.getData("error")!
			
			print(error.localizedDescription)
			self.getBundleWatcher(date: date).handle(chain.getData("error"), nil)
			
			self.registerListeners(date: date)
			
			then(false)
		}.start()
	}
	
}
