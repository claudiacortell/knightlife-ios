//
//  SportsManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class SportsManager: DataManager<SportsPrefModule>
{
	static let instance = SportsManager()
	private static let dataKey = "useradded"
	
	private(set) var userAdded: [SportTeam]
	private(set) var meetings: [EnscribedDate: DailySportsList]
	
	init()
	{
		self.userAdded = []
		self.meetings = [:]
		
		super.init(name: "Sports Manager", module: SportsPrefModule(self))

		self.loadDataModule()
	}
	
	func retrieveMeetings(_ date: EnscribedDate = TimeUtils.todayEnscribed, onlyAdded: Bool = true) -> [SportsMeetingWrapper]
	{
		var wrapperList: [SportsMeetingWrapper] = []
		if let sportsList = self.meetings[date]
		{
			for (team, meeting) in sportsList.sports
			{
				if self.userAdded.contains(team)
				{
					let wrapper = SportsMeetingWrapper(team: team, date: date, duration: meeting.duration)
					wrapperList.append(wrapper)
				}
			}
		}
		return wrapperList
	}
	
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
