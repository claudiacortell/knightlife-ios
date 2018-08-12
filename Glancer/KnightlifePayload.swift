//
//  KnightlifePayload.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/2/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class KnightlifePayload<MainPayload: Unboxable>: WebCallPayload {
	
	let content: MainPayload?
	let error: String?
	let attributes: KnightlifePayloadAttributes
	
	required init(unboxer: Unboxer) throws {
		self.content = unboxer.unbox(key: "content")
		self.error = unboxer.unbox(key: "error")
		self.attributes = try unboxer.unbox(key: "attributes")
	}
	
}

class KnightlifeListPayload<MainPayload: Unboxable>: WebCallPayload {
	
	let content: [MainPayload]?
	let error: String?
	let attributes: KnightlifePayloadAttributes
	
	required init(unboxer: Unboxer) throws {
		self.content = unboxer.unbox(key: "content", allowInvalidElements: true)
		self.error = unboxer.unbox(key: "error")
		self.attributes = try unboxer.unbox(key: "attributes")
	}
	
}

struct KnightlifePayloadAttributes: WebCallPayload {
	
	let day: String?
	let type: String?
	
	init(unboxer: Unboxer) throws {
		self.day = unboxer.unbox(key: "day")
		self.type = unboxer.unbox(key: "type")
	}
	
}
