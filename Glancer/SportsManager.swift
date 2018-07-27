//
//  SportsManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

class SportsManager: Manager
{
	static let instance = SportsManager()
	
	private(set) var meetings: [Date: DailySportsList]
	
	var sportsPrefModule: SportsPrefModule!
	
	init()
	{
		self.meetings = [:]
		
		super.init("Sports Manager")

		self.sportsPrefModule = SportsPrefModule(self)
		self.registerStorage(self.sportsPrefModule)
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
