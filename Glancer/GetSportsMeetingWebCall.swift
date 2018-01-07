//
//  GetSportsMeetingWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/4/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetMeetingWebCall: WebCall<SportsManager, GetSportsMeetingResponse, SportMeeting>
{
	let sport: SportTeam
	let date: EnscribedDate
	
	init(manager: SportsManager, sport: SportTeam, date: EnscribedDate)
	{
		self.sport = sport
		self.date = date
		super.init(manager: manager, call: "request/sports.php")
		
		self.parameter("team", val: String(sport.id)).parameter("date", val: date.string)
	}
	
	override func handleCall(url: String, call: String, completeCall: String, success: Bool, error: String?, data: SportMeeting?)
	{
		
	}
}
