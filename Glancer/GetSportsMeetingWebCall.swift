//
//  GetSportsMeetingWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/4/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

class GetMeetingWebCall: UnboxWebCall<GetSportsMeetingResponse, SportMeeting>
{
	let manager: SportsManager
	let sport: SportTeam
	let date: Date
	
	init(manager: SportsManager, sport: SportTeam, date: Date)
	{
		self.manager = manager
		self.sport = sport
		self.date = date
		
		super.init(call: "request/sports.php")
		
		self.parameter("tm", val: String(sport.id))
		self.parameter("dt", val: date.webSafeDate)
	}
	
}
