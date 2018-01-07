//
//  GetMenuWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class GetMenuWebCall: WebCall<LunchManager, GetMenuResponse, LunchMenu>
{
	let date: EnscribedDate
	
	init(_ manager: LunchManager, date: EnscribedDate, token: ResourceFetchToken)
	{
		self.date = date
		
		super.init(manager: manager, converter: GetMenuConverter(), token: token, call: "request/lunch.php")
		
		self.parameter("date", val: date.string)
	}
	
	override func handleCall(url: String, call: String, completeCall: String, success: Bool, error: String?, data: LunchMenu?)
	{
		if error != nil
		{
			self.manager.out(error!)
		}
	}
}
