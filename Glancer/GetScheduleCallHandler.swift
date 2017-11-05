//
//  GetScheduleCallHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetScheduleCallHandler: WebCallHandler
{
	let manager: ScheduleManager
	
	init(_ manager: ScheduleManager)
	{
		self.manager = manager
	}
	
	func handleCall(url: String, call: String, completeCall: String, success: Bool, error: String?, data: GetScheduleResponse?)
	{
		if success && data != nil
		{
			manager.templateResponded(response: data!)
		} else
		{
			manager.out("Schedule handling error: \(error!)")
			manager.lastTemplateFetch = .failure
		}
	}
}
