//
//  WebCallHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Unbox

class WebCallHandler<WebCallManager: Manager, DataContainer: WebCallResult, Result>
{
	let manager: WebCallManager
	
	init(manager: WebCallManager)
	{
		self.manager = manager
	}
	
	func handleCall(url: String, call: String, completeCall: String, success: Bool, error: String?, data: Result?) { }
}
