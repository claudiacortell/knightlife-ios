//
//  LunchManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class LunchManager: Manager {
	
	static let instance = LunchManager()
	
	private(set) var lunches: [String: LunchMenu] = [:]
	private var lunchWatchers: [String: ResourceWatcher<LunchMenu>] = [:]
	
	init() {
		super.init("Lunch Manager")
	}
	
	func getLunchWatcher(date: Date) -> ResourceWatcher<LunchMenu> {
		if self.lunchWatchers[date.webSafeDate] == nil {
			self.lunchWatchers[date.webSafeDate] = ResourceWatcher<LunchMenu>()
		}
		return self.lunchWatchers[date.webSafeDate]!
	}
	
	func fetchLunchMenu(date: Date) {
		GetMenuWebCall(date: date).callback() {
			result in
			
			var item: LunchMenu?
			var fail: Error?
			
			switch result {
			case .success(let menu):
				item = menu
			case .failure(let error):
				fail = error
			}
			
			self.lunches[date.webSafeDate] = item
			self.getLunchWatcher(date: date).handle(fail, item)
		}.execute()
	}
	
}
