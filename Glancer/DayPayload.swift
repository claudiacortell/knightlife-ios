//
//  DayPayload.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/27/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class DayPayload: WebCallPayload {
	
	let changed: Bool?
	let notices: [DayNoticePayload]?
	
	let blocks: [BlockPayload]
	
	required init(unboxer: Unboxer) throws {
		self.changed = unboxer.unbox(key: "changed")
		self.notices = unboxer.unbox(key: "notices")
		
		self.blocks = try unboxer.unbox(key: "blocks")
	}
	
}

class DayNoticePayload: WebCallPayload {
	
	let priority: Int
	let message: String
	
	required init(unboxer: Unboxer) throws {
		self.priority = try unboxer.unbox(key: "priority")
		self.message = try unboxer.unbox(key: "message")
	}
	
}
