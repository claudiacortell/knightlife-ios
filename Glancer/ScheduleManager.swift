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
		
		let call = GetScheduleWebCall(self, fetchToken: curFetch)
		call.addCallback(
		{ fetch in
			if fetch.hasData && fetch.result == .success // Successful fetch
			{
				self.scheduleTemplate = fetch.data!
				self.templateStatus.setResult(ResourceFetch(curFetch, .success, fetch.data!, true))
			} else
			{
				self.scheduleTemplate = [:] // Clear data.
				self.templateStatus.setResult(ResourceFetch(curFetch, .failure, nil, fetch.result == .success))
			}
		})
		
		return call
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
		
		let fetchToken = ResourceFetchToken(.remoteFetch)
		let patchCall = GetPatchWebCall(self, day: date, fetchToken: fetchToken)
		patchCall.addCallback(
		{ fetch in
			if fetch.result != .success // No patches retrieved.
			{
				self.schedulePatches[date] = nil // Clear previously loaded
				
				if let connected = fetch.madeConnection, !connected
				{
					execute(ResourceFetch(fetchToken, .failure, nil))
					return
				}
				
				if let dayId = TimeUtils.getDayOfWeek(date), let templateSchedule = self.scheduleTemplate[dayId]
				{
					self.associatedSchedules[date] = templateSchedule
					execute(ResourceFetch(fetchToken, .success, templateSchedule))
					return
				}
				self.out("Failed to load patches, no template schedule found.")
				execute(ResourceFetch(fetchToken, .failure, nil))
				return
			} else if fetch.hasData // Succesful w/ Data
			{
				self.schedulePatches[date] = fetch.data!
				self.associatedSchedules[date] = fetch.data!
				execute(fetch)
				
				return
			}
			
			execute(ResourceFetch(fetchToken, .failure, nil))
		})
		
		if !self.templateStatus.successful // If there is no status or the previous fetch failed
		{
			let templateCall = self.getTemplateCall()
			templateCall.addCallback(
			{ fetch in
				if fetch.result != .success // Failed to get template schedule so we're going to cancel this all
				{
					execute(ResourceFetch(fetchToken, fetch.result, nil))
					return
				}
				
				patchCall.execute() // Execute the patch call after the template's done loading.
			})
			templateCall.execute()
		} else
		{
			patchCall.execute() // only check for patches since the schedule's already loaded.
		}
		
		return fetchToken
	}
}
