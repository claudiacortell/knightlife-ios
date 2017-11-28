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
	
	var templateStatus: FetchContainer<[DayID: DaySchedule]> = FetchContainer(fetch: ResourceFetchToken(.none))
	var scheduleTemplate: [DayID: DaySchedule]

	var schedulePatches: [EnscribedDate: DaySchedule]
	
	var associatedSchedules: [EnscribedDate: DaySchedule] // Used for quick reference.
	
	init()
	{
		self.scheduleTemplate = [:]
		self.schedulePatches = [:]
		
		self.associatedSchedules = [:]
		
		super.init(name: "Schedule Manager")
	}
	
	func reloadScheduleTemplate()
	{
		getTemplateCall().execute()
	}
	
	private func getTemplateCall() -> GetScheduleWebCall
	{
		let curFetch = ResourceFetchToken(.localFetch)
		self.templateStatus = FetchContainer<[DayID: DaySchedule]>(fetch: curFetch)
		
		self.callEvent(ScheduleTemplateAttemptLoadEvent())

		return GetScheduleWebCall(self, fetchToken: curFetch, callback: { fetch in
			if fetch.hasData && fetch.result == .success // Successful fetch
			{
				self.scheduleTemplate = fetch.data!
				self.templateStatus.setResult(ResourceFetch(curFetch, .success, fetch.data!))
				
				self.callEvent(ScheduleTemplateLoadEvent(successful: true))
			} else
			{
				self.scheduleTemplate = [:] // Clear data.
				self.templateStatus.setResult(ResourceFetch(curFetch, .failure, nil))
				
				self.callEvent(ScheduleTemplateLoadEvent(successful: false))
			}
		})
	}
	
	@discardableResult
	func retrieveBlockList(hard: Bool = false, date: EnscribedDate = TimeUtils.todayEnscribed, execute: @escaping (ResourceFetch<DaySchedule>) -> Void = {fetch in}) -> ResourceFetchToken
	{
		if !hard && self.associatedSchedules[date] != nil
		{
			let schedule = self.associatedSchedules[date]!
			let fetchToken = ResourceFetchToken(.localFetch)
			let fetch = ResourceFetch(fetchToken, .success, schedule)
			execute(fetch)
			return fetchToken
		}
		
		// Search for patches
		if !hard, let patchBlockList = schedulePatches[date]
		{
			let fetchToken = ResourceFetchToken(.localFetch)
			let fetch = ResourceFetch(fetchToken, .success, patchBlockList)
			self.associatedSchedules[date] = patchBlockList
			
			execute(fetch)
			return fetchToken // If we have a locally downloaded patch, return it.
		}
		
		self.callEvent(SchedulePatchAttemptLoadEvent(date: date))
		
		let fetchToken = ResourceFetchToken(.remoteFetch)
		let patchCall = GetPatchWebCall(self, day: date, fetchToken: fetchToken, callback: { fetch in
			if fetch.result != .success // No patches retrieved.
			{
				let event = SchedulePatchLoadEvent(successful: false, date: date, patch: nil)
				if let dayId = TimeUtils.getDayOfWeek(date), let templateSchedule = self.scheduleTemplate[dayId]
				{
					self.associatedSchedules[date] = templateSchedule
					execute(ResourceFetch(fetchToken, .success, templateSchedule))
					
					self.callEvent(event)
					return
				}
				print("Failed to load patches, no template schedule found.")
				execute(ResourceFetch(fetchToken, .failure, nil))
				
				self.callEvent(event)
				return
			} else if fetch.hasData // Succesful w/ Data
			{
				self.schedulePatches[date] = fetch.data!
				self.associatedSchedules[date] = fetch.data!
				execute(fetch)
				
				self.callEvent(SchedulePatchLoadEvent(successful: true, date: date, patch: fetch.data!))
				return
			}
			
			execute(ResourceFetch(fetchToken, .failure, nil))
			self.callEvent(SchedulePatchLoadEvent(successful: false, date: date, patch: nil))
		})
		
		if !self.templateStatus.successful // If there is no status or the previous fetch failed
		{
			let templateCall = self.getTemplateCall()
			templateCall.next(patchCall)
			templateCall.execute()
		} else
		{
			patchCall.execute()
		}
		
		return fetchToken
	}
}
