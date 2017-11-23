//
//  GetSportsMeetingConverter.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/22/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class GetSportsMeetingConverter: WebCallResultConverter<SportsManager, GetSportsMeetingResponse, SportMeeting>
{
	override func convert(_ data: GetSportsMeetingResponse) -> SportMeeting?
	{
		return nil
	}
}
