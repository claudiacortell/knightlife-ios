//
//  GetScheduleWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetScheduleWebCall: WebCall<ScheduleManager, GetScheduleResponse, [DayID: DaySchedule]>
{    
	init(_ manager: ScheduleManager, fetchToken: ResourceFetchToken, callback: @escaping (ResourceFetch<[DayID: DaySchedule]>) -> Void)
	{
		super.init(manager: manager, converter: GetScheduleConverter(), fetchToken: fetchToken, callback: callback, call: "request/schedule.php")
	}
    
	override func handleCall(url: String, call: String, completeCall: String, success: Bool, error: String?, data: [DayID : DaySchedule]?)
	{
		if success
		{
			manager.out("Successfully downloaded template schedule")
		} else
		{
			manager.out("An error occured during web call: \(call): \(error!)")
		}
	}
}
