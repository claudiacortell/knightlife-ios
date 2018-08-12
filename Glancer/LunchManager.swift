//
//  LunchManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class LunchManager: Manager, PushRefreshListener {
	
	static let instance = LunchManager()
	
	var refreshListenerType: [PushRefreshType] = [.LUNCH]
	
	private(set) var showAllergens: Bool!
	let showAllergensWatcher = ResourceWatcher<Bool>()
	
	private(set) var lunches: [String: LunchMenu] = [:]
	private var lunchWatchers: [String: ResourceWatcher<LunchMenu>] = [:]
	
	init() {
		super.init("Lunch Manager")
		
		PushNotificationManager.instance.addListener(type: .REFRESH, listener: self)
		self.registerStorage(ShowAllergyStorage(manager: self))
	}
	
	func clearCache() {
		self.lunches.removeAll()
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
	
	func doListenerRefresh(date: Date) {
		self.fetchLunchMenu(date: date, force: true)
	}
	
	func fetchLunchMenu(date: Date, force: Bool = false, then: @escaping (WebCallResult<LunchMenu>) -> Void = {_ in}) {
		if !force, let menu = self.getCachedMenu(date: date) {
			then(WebCallResult.success(result: menu))
			return
		}
		
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
