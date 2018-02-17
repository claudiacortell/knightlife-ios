//
//  GetTemplateResourceHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/14/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class GetTemplateResourceHandler: ResourceHandler<[DayID : WeekdaySchedule]>
{
	let manager: ScheduleManager
	private var template: [DayID : WeekdaySchedule] = [:]
	
	init(_ manager: ScheduleManager)
	{
		self.manager = manager
	}
	
	func reloadTemplate(callback: @escaping (FetchError?, [DayID: WeekdaySchedule]) -> Void = {_,_ in})
	{
		let call = GetScheduleWebCall(self.manager)
		call.callback =
		{ error, result in
			self.template = result ?? [:]
			callback(error, self.template)
			
			if let success = result
			{
				self.success(success)
			} else if error == nil
			{
				self.success(result)
			} else
			{
				self.failure(error!)
			}
		}
		call.execute()
	}
	
	@discardableResult
	func getTemplate(_ day: DayID, hard: Bool = false, callback: @escaping (FetchError?, WeekdaySchedule?) -> Void = {_,_ in}) -> WeekdaySchedule?
	{
		if hard || self.template.isEmpty // Requires reload
		{
			self.reloadTemplate(callback:
			{ error, result in
				callback(error, self.template[day])
			})
			return nil
		} else
		{
			return template[day]
		}
	}
}
