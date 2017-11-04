//
//  GetSportsMeetingsCallHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/4/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetSportsMeetingsCallHandler: WebCallHandler<GetSportsMeetingsResponse>
{
	let manager: SportsManager
	
	init(_ manager: SportsManager)
	{
		self.manager = manager
	}
	
	override func handleCall(url: String, call: String, completeCall: String, success: Bool, error: String?, data: GetSportsMeetingsResponse?)
	{
		// TODO
	}
}
