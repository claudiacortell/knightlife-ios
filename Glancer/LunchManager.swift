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
	
	private(set) var showAllergens: Bool!
	let showAllergensWatcher = ResourceWatcher<Bool>()
	
	private(set) var lunches: [String: LunchMenu] = [:]
	private var lunchWatchers: [String: ResourceWatcher<LunchMenu>] = [:]
	
	init() {
		super.init("Lunch Manager")
		
		self.registerStorage(ShowAllergyStorage(manager: self))
	}
	
	func loadedShowAllergens(value: Bool) {
		self.showAllergens = value
	}
	
	func setShowAllergens(value: Bool) {
		self.showAllergens = value
		self.saveStorage()
		
		self.showAllergensWatcher.handle(nil, self.showAllergens)
	}
	
	func getCachedMenu(date: Date) -> LunchMenu? {
		return self.lunches[date.webSafeDate]
	}
	
	func getLunchWatcher(date: Date) -> ResourceWatcher<LunchMenu> {
		if self.lunchWatchers[date.webSafeDate] == nil {
			self.lunchWatchers[date.webSafeDate] = ResourceWatcher<LunchMenu>()
		}
		return self.lunchWatchers[date.webSafeDate]!
	}
	
	func fetchLunchMenu(date: Date, then: @escaping (WebCallResult<LunchMenu>) -> Void = {_ in}) {
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
			
			then(result)
		}.execute()
	}
	
}
