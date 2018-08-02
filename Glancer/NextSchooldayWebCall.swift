//
//  NextSchooldayWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/2/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class NextSchooldayWebCall: UnboxWebCall<KnightlifePayload<FakeWebCall>, Date> {
	
	init(today: Date) {
		super.init(call: "schedule/next")
		
		self.parameter("date", val: today.webSafeDate)
	}
	
	override func convertToken(_ data: KnightlifePayload<FakeWebCall>) -> Date? {
		return Date.fromWebDate(string: data.attributes.day ?? "")
	}
	
}

class FakeWebCall: WebCallPayload {
	
	required init(unboxer: Unboxer) throws {
		
	}
	
}
