//
//  GetPatchResourceHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class GetPatchResourceHandler: ResourceWatcher<(EnscribedDate, DateSchedule?)> {
	
	let manager: ScheduleManager
	private var schedules: [EnscribedDate: DateSchedule]
	
	init(_ manager: ScheduleManager) {
		self.manager = manager
		self.schedules = [:]
		
		super.init()
	}
	
	func reloadLocalPatches(callback: @escaping (ResourceWatcherError?, (EnscribedDate, DateSchedule?)) -> Void = {_,_ in}) {
		for date in self.schedules.keys {
			getSchedule(date, hard: true) {
				error, data in
				
				callback(error, (date, data))
			}
		}
	}
	
	@discardableResult
	func getSchedule(_ date: EnscribedDate, hard: Bool = false, callback: @escaping (ResourceWatcherError?, DateSchedule?) -> Void = {_,_ in}) -> DateSchedule? {
		if hard || self.schedules[date] == nil {
			GetPatchWebCall(manager, date: date).callback() {
				error, result in
				
				callback(error, result)
				
				if let success = result {
					self.schedules[date] = success
					self.handle(nil, (date, success))
				} else if error == nil {
					self.schedules[date] = nil
					self.handle(nil, (date, nil))
				} else {
					self.schedules[date] = nil
					self.handle(error!, nil)
				}
			}.execute()
			return nil
		} else
		{
			return schedules[date]
		}
	}
	
}
