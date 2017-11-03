//
//  GetScheduleWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class GetScheduleWebCall: WebCall<GetScheduleResponseContainer>
{
	init(handler: GetScheduleCallHandler)
	{
		super.init(call: "schedule")
		self.token()
	}
	
	override func handleData(data: Data) -> GetScheduleResponseContainer?
	{
		return nil
	}
}
