//
//  GetEventsResponse.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class GetEventsResponse: WebCallPayload
{
	let events: [GetEventsResponseEvent]
	
	required init(unboxer: Unboxer) throws
	{
		self.events = try unboxer.unbox(keyPath: "events", allowInvalidElements: false)
	}
}

class GetEventsResponseEvent: WebCallPayload
{
	let blockId: String
	let mandatory: Bool
	let audience: [Int]
	
	let name: String
	var description: String?
	
	required init(unboxer: Unboxer) throws
	{
		self.blockId = try unboxer.unbox(key: "blockId")
		self.mandatory = try unboxer.unbox(key: "mandatory")
		self.audience = try unboxer.unbox(key: "audience")

		self.name = try unboxer.unbox(key: "name")
		self.description = unboxer.unbox(key: "description")
	}
}
