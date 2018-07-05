//
//  GetSportsMeetingResponse.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/4/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

struct GetSportsMeetingResponse: WebCallPayload
{
	var type: Int
	
	var start: String
	var finish: String?
	
	var home: Bool?
	var opponent: String?
	var location: String?
	
	var changed: Bool?
}

extension GetSportsMeetingResponse
{
	init(unboxer: Unboxer) throws
	{
		self.type = try unboxer.unbox(key: "event.type")
		
		self.start = try unboxer.unbox(key: "event.start")
		self.finish = unboxer.unbox(key: "event.finish")
		
		self.home = unboxer.unbox(key: "event.home")
		self.opponent = unboxer.unbox(key: "event.opponent")
		self.location = unboxer.unbox(key: "event.location")
		
		self.changed = unboxer.unbox(key: "event.changed")
	}
}
