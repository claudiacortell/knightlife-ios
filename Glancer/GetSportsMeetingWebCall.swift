//
//  GetSportsMeetingWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/4/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Charcore

class GetMeetingWebCall: WebCall<GetSportsMeetingResponse, SportMeeting>
{
	let manager: SportsManager
	let sport: SportTeam
	let date: EnscribedDate
	
	init(manager: SportsManager, sport: SportTeam, date: EnscribedDate)
	{
		self.manager = manager
		self.sport = sport
		self.date = date
		
		super.init(call: "request/sports.php")
		
		self.parameter("tm", val: String(sport.id))
		self.parameter("dt", val: date.string)
	}
	
	override func handleTokenConversion(_ data: GetSportsMeetingResponse) -> SportMeeting?
	{
		return nil
	}
	
	override func handleCall(error: ResourceFetchError?, data: SportMeeting?)
	{
		
	}
}
