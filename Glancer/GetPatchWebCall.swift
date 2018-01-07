//
//  GetPatchesWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetPatchWebCall: WebCall<ScheduleManager, GetPatchResponse, DateSchedule>
{
	let date: EnscribedDate
	
	init(_ manager: ScheduleManager, date: EnscribedDate, token: ResourceFetchToken)
	{
		self.date = date
		super.init(manager: manager, converter: GetPatchConverter(date), token: token, call: "request/schedule.php")
				
		self.parameter("date", val: date.string)
	}
	
	override func handleCall(url: String, call: String, completeCall: String, success: Bool, error: String?, data: DateSchedule?)
	{
		if success
		{
			manager.out("Successfully retrieved patch for date: \(self.date.string)")
		} else if error! == "Invalid data."
		{
			manager.out("No patch schedule for date: \(self.date.string)")
		} else
		{
			manager.out("An error occured during web call: \(call): \(error!)")
		}
	}
}
