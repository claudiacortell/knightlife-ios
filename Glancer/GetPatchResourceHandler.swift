//
//  GetPatchResourceHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class GetPatchResourceHandler: ResourceHandler<(EnscribedDate, DateSchedule?)>
{
	let manager: ScheduleManager
	private var schedules: [EnscribedDate: DateSchedule] = [:]
	
	init(_ manager: ScheduleManager)
	{
		self.manager = manager
	}
	
	func reloadLocalPatches(callback: @escaping (FetchError?, (EnscribedDate, DateSchedule?)) -> Void = {_,_ in})
	{
		for date in self.schedules.keys
		{
			getSchedule(date, hard: true, callback:
			{ error, data in
				callback(error, (date, data))
			})
		}
	}
	
	@discardableResult
	func getSchedule(_ date: EnscribedDate, hard: Bool = false, callback: @escaping (FetchError?, DateSchedule?) -> Void = {_,_ in}) -> DateSchedule?
	{
		if hard || self.schedules[date] == nil // Requires reload
		{
			let call = GetPatchWebCall(manager, date: date)
			call.callback =
			{ error, result in
				callback(error, result)
				
				if let success = result
				{
					self.schedules[date] = success
					self.success((date, success))
				} else if error == nil
				{
					self.schedules[date] = nil
					self.success((date, nil))
				} else
				{
					self.schedules[date] = nil
					self.failure(error!)
				}
			}
			call.execute()
			return nil
		} else
		{
			return schedules[date]
		}
	}
}
