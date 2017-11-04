//
//  GetPatchesCallHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetPatchesCallHandler: WebCallHandler<GetPatchesResponse>
{
	let manager: ScheduleManager
	
	init(_ manager: ScheduleManager)
	{
		self.manager = manager
	}
	
	override func handleCall(url: String, call: String, completeCall: String, success: Bool, error: String?, data: GetPatchesResponse?)
	{
		if success && data != nil
		{
			manager.patchesResponded(response: data!)
		} else
		{
			manager.out("Patch handling error: \(error!)")
			manager.lastPatchFetch = .failure
		}
	}
}
