//
//  GetTemplateResourceHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/14/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class GetTemplateResourceHandler: ResourceWatcher<[Day : WeekdaySchedule]> {
	
	let manager: ScheduleManager
	private var template: [Day: WeekdaySchedule]
	
	init(_ manager: ScheduleManager) {
		self.manager = manager
		self.template = [:]
		
		super.init()
	}
	
	func reloadTemplate(callback: @escaping (ResourceWatcherError?, [Day: WeekdaySchedule]) -> Void = {_,_ in}) {
		GetScheduleWebCall(self.manager).callback() {
			error, result in
			
			self.template = result ?? [:]
			callback(error, self.template)
			
			if let success = result {
				self.handle(nil, success)
			} else if error == nil {
				self.handle(nil, result)
			} else {
				self.handle(error!, nil)
			}
		}.execute()
	}
	
	@discardableResult
	func getTemplate(_ day: Day, hard: Bool = false, callback: @escaping (ResourceWatcherError?, WeekdaySchedule?) -> Void = {_,_ in}) -> WeekdaySchedule? {
		if hard || self.template.isEmpty {
			self.reloadTemplate() {
				error, result in
				
				callback(error, self.template[day])
			}
			return nil
		} else {
			return template[day]
		}
	}
	
}
