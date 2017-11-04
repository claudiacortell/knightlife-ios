//
//  GetSportsMeetingsWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/4/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetMeetingsWebCall: WebCall<GetSportsMeetingsResponse>
{
	let sport: SportTeam
	
	init(sport: SportTeam)
	{
		self.sport = sport
		super.init(call: "sports")
	}
	
	override func handleData(data: Data) -> GetSportsMeetingsResponse?
	{
		/* Override point */
		return nil
	}
}
