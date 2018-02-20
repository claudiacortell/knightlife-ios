//
//  GetPatchesResponse.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Unbox

struct GetPatchResponse: WebCallResult
{
	var subtitle: String?
	var blocks: [GetPatchResponseBlock]
	var changed: Bool?
	
	init(unboxer: Unboxer) throws
	{		
		self.subtitle = unboxer.unbox(key: "subtitle")
		self.changed = unboxer.unbox(key: "changed")
		self.blocks = try unboxer.unbox(keyPath: "blocks", allowInvalidElements: false)
	}
}

struct GetPatchResponseBlock: WebCallResult
{
	var blockId: String
	var startTime: String
	var endTime: String
	
	var overrideColor: String?
	
	var variation: Int?
//	var associatedBlock: String?
	
	var customName: String?
	
	init(unboxer: Unboxer) throws
	{
		self.blockId = try unboxer.unbox(key: "id")
		self.startTime = try unboxer.unbox(key: "start")
		self.endTime = try unboxer.unbox(key: "end")
		
		self.overrideColor = unboxer.unbox(key: "color")
		
		self.variation = unboxer.unbox(key: "variation")
//		self.associatedBlock = unboxer.unbox(key: "association")
		
		self.customName = unboxer.unbox(key: "name")
	}
}
