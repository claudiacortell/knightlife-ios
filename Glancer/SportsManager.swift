//
//  SportsManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Charcore

class SportsManager: Manager
{
	static let instance = SportsManager()
	
	private(set) var meetings: [EnscribedDate: DailySportsList]
	
	var sportsPrefModule: SportsPrefModule
	{
		return self.getModule("addedTeams") as! SportsPrefModule
	}
	
	init()
	{
		self.meetings = [:]
		
		super.init("Sports Manager")

		self.registerModule(SportsPrefModule(self, name: "addedTeams")) // Register preference module
    }
	
	
	
//	func retrieveMeetings(_ date: EnscribedDate = TimeUtils.todayEnscribed, onlyAdded: Bool = true) -> [SportsMeetingWrapper]
//	{
//		var wrapperList: [SportsMeetingWrapper] = []
//		if let sportsList = self.meetings[date]
//		{
//			for (team, meeting) in sportsList.sports
//			{
//				if self.sportsPrefModule.containsItem(team)
//				{
//					let wrapper = SportsMeetingWrapper(team: team, date: date, duration: meeting.duration)
//					wrapperList.append(wrapper)
//				}
//			}
//		}
//		return wrapperList
//	}
	
	func getTeamById(id: Int) -> SportTeam?
	{
		for team in TeamDeclarations.values
		{
			if team.id == id
			{
				return team
			}
		}
		return nil
	}
}
