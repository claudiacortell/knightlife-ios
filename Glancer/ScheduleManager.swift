//
//  ScheduleManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class ScheduleManager: Manager
{	
	static let instance = ScheduleManager()
	
	var template: FetchContainer<[DayID: DaySchedule]>!
	var schedulePatches: [EnscribedDate: FetchContainer<DaySchedule>]
	
	init()
	{
		self.template = FetchContainer(ResourceFetchToken())
		self.schedulePatches = [:]
		
		super.init(name: "Schedule Manager")
		
		self.fetchTemplate()
	}
	
	func getTemplate() -> LocalResource<[DayID: DaySchedule]>
	{
		return LocalResource(self.template.status, self.template.data)
	}
	
	func getSchedule(_ day: DayID) -> LocalResource<DaySchedule>
	{
		return LocalResource(self.template.status, self.template.data![day])
	}
	
	func getSchedule(_ date: EnscribedDate) -> LocalResource<DaySchedule>
	{
		let status = self.schedulePatches[date] == nil ? .dead : self.schedulePatches[date]!.status
		if status == .success, let schedule = self.schedulePatches[date]?.data
		{
			return LocalResource(status, schedule)
		}
		return LocalResource(status, nil)
	}
	
	@discardableResult
	func fetchTemplate(_ callback: @escaping (ResourceFetch<[DayID: DaySchedule]>) -> Void = {_ in}) -> ResourceFetchToken
	{
		let token = ResourceFetchToken()
		self.template = FetchContainer(token)

		let call = GetScheduleWebCall(self, token: token)
		call.addCallback(
		{ fetch in
			self.template.setResult(fetch)
			callback(fetch)
		})
		call.execute()
		return token
	}
	
	@discardableResult
	func fetchDaySchedule(_ date: EnscribedDate, _ callback: @escaping (ResourceFetch<DaySchedule>) -> Void = {_ in}) -> ResourceFetchToken
	{
		let token = ResourceFetchToken()
		self.schedulePatches[date] = FetchContainer(token)
		
		let call = GetPatchWebCall(self, date: date, token: token)
		call.addCallback(
		{ fetch in
			if self.schedulePatches[date] != nil
			{
				self.schedulePatches[date]!.setResult(fetch)
			}
			callback(fetch)
		})
		call.execute()
		return token
	}
}
