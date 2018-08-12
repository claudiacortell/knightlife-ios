//
//  BlockPayload.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/27/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Unbox
import AddictiveLib

class BlockPayload: WebCallPayload {
	
	let id: String
	let variation: Int?

	let start: String
	let end: String

	let custom: CustomBlockPayload?
	
	required init(unboxer: Unboxer) throws {
		self.id = try unboxer.unbox(key: "id")
		self.variation = unboxer.unbox(key: "variation")
		
		self.start = try unboxer.unbox(key: "start")
		self.end = try unboxer.unbox(key: "end")
		
		self.custom = unboxer.unbox(key: "custom")
	}
}

class CustomBlockPayload: WebCallPayload {
	
	let name: String
	let color: String
	
	let location: String?
	
	required init(unboxer: Unboxer) throws {
		self.name = try unboxer.unbox(key: "name")
		self.color = try unboxer.unbox(key: "color")
		
		self.location = unboxer.unbox(key: "location")
	}
	
}
