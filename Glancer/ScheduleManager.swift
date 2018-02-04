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
	
	private var schedule: WeekdaySchedule?
	private var patches: [EnscribedDate: DateSchedule] = [:]
	
	private var scheduleSuccessCallbacks: [(WeekdaySchedule) -> Void]
	private var scheduleFailureCallbacks: [(FetchError) -> Void]
	
	//success: @escaping ((remote: Bool, menu: LunchMenu)) -> Void, failure: @escaping (FetchError) -> Void
	
	var variationModule: ScheduleVariationPrefsModule
	{
		return self.getModule("variation") as! ScheduleVariationPrefsModule
	}
	
	init()
	{
		super.init(name: "Schedule Manager")
		
		self.registerModule(ScheduleVariationPrefsModule(self, name: "variation"))
	}
	
	func getVariation(_ day: DayID) -> Int
	{
		return self.variationModule.getItem(day) ?? 0
	}
	
	func getVariation(_ date: EnscribedDate) -> Int
	{
		return self.variationModule.getItem(date.dayOfWeek) ?? 0
	}
	
	func getTemplate() -> RemoteResource<[DayID: WeekdaySchedule]>
	{
		return RemoteResource(self.template.status, self.template.data)
	}
	
	func getSchedule(_ day: DayID) -> RemoteResource<WeekdaySchedule>
	{
		return RemoteResource(self.template.status, self.template.data![day])
	}
	
	func getSchedule(_ date: EnscribedDate) -> RemoteResource<DateSchedule>
	{
		let status = self.schedulePatches[date] == nil ? .dead : self.schedulePatches[date]!.status
		if status == .loaded, let schedule = self.schedulePatches[date]?.data
		{
			return RemoteResource(status, schedule)
		}
		return RemoteResource(status, nil)
	}
	
	@discardableResult
	func fetchTemplate(_ callback: @escaping (ResourceFetch<[DayID: WeekdaySchedule]>) -> Void = {_ in}) -> ResourceFetchToken
	{
		let token = ResourceFetchToken()
		self.template = FetchContainer(token)

		let call = GetScheduleWebCall(self, token: token)
		
		call.addCallback(
		{ fetch in
			self.template.setResult(fetch)
		})
		
		call.addCallback(
		{ fetch in
			callback(fetch)
		})
		
		call.execute()
		return token
	}
	
	@discardableResult
	func fetchDaySchedule(_ date: EnscribedDate, _ callback: @escaping (ResourceFetch<DateSchedule>) -> Void = {_ in}) -> ResourceFetchToken
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
		})
		
		call.addCallback(
		{ fetch in
			callback(fetch)
		})
		
		call.execute()
		return token
	}
}
