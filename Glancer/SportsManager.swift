//
//  SportsManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class SportsManager: Manager
{
	static let instance = SportsManager()
	
	var userAdded: [SportTeam]
	var meetings: [EnscribedDate: DailySportsList]
	
	init()
	{
		self.userAdded = []
		self.meetings = [:]
		
		super.init(name: "Sports Manager")
	}
	
	func loadUserAdded()
	{
		
	}
	
	func saveUserAdded()
	{
		
	}
	
	
}
