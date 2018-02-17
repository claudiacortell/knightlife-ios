//
//  RegistrationWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/16/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Unbox

class RegistrationWebCall: WebCall<DummyResult, Any>
{
	init()
	{
		super.init(call: "device/register")
		self.deviceParam()
	}
	
	override func handleTokenConversion(_ data: DummyResult) -> Any?
	{
		return nil
	}
	
	override func handleCall(error: FetchError?, data: Any?)
	{
		
	}
}
