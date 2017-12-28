//
//  GetPatchesWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetPatchWebCall: WebCall<ScheduleManager, GetPatchResponse, DaySchedule>
{
	let date: EnscribedDate
	
	init(_ manager: ScheduleManager, date: EnscribedDate, token: ResourceFetchToken)
	{
		self.date = date
		super.init(manager: manager, converter: GetPatchConverter(), token: token, call: "request/schedule.php")
				
		self.parameter("date", val: date.toString())
	}
	
	override func handleCall(url: String, call: String, completeCall: String, success: Bool, error: String?, data: DaySchedule?)
	{
		if success
		{
			manager.out("Successfully retrieved patch for date: \(self.date.toString())")
		} else if error! == "Invalid data."
		{
			manager.out("No patch schedule for date: \(self.date.toString())")
		} else
		{
			manager.out("An error occured during web call: \(call): \(error!)")
		}
	}
}
