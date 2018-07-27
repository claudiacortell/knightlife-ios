//
//  GetPatchesWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class GetPatchWebCall: UnboxWebCall<GetPatchResponse, DateSchedule> {
	
	let date: Date
	
	init(date: Date) {
		self.date = date
		
		super.init(call: "schedule")
		
		self.parameter("date", val: date.webSafeDate)
	}
	
	override func convertToken(_ response: GetPatchResponse) -> DateSchedule? {
		var blocks: [Block] = []
		
		for responseBlock in response.blocks {
			guard let id = BlockID.fromStringValue(name: responseBlock.blockId) else {
				print("Recieved an invalid block id: \(responseBlock.blockId)")
				continue
			}
						
			guard let startTime = Date.fromWebTime(string: responseBlock.startTime), let endTime = Date.fromWebTime(string: responseBlock.endTime) else {
				print("Failed to parse a date.")
				continue
			}
			
			guard let adjustedStart = Date.mergeDateAndTime(date: self.date, time: startTime), let adjustedEnd = Date.mergeDateAndTime(date: self.date, time: endTime) else {
				print("Failed to join date and time.")
				continue
			}
			
			let variation = responseBlock.variation

			let customName = responseBlock.customName
			let color = UIColor(hex: responseBlock.overrideColor ?? "")

			let block = Block(id: id, time: TimeDuration(start: adjustedStart, end: adjustedEnd), variation: variation, customName: customName, color: color)
			blocks.append(block)
		}
		
		var standinDay: DayOfWeek?
		if response.replaceDayId != nil {
			standinDay = DayOfWeek(rawValue: response.replaceDayId!)
		}
		
		let daySchedule = DateSchedule(date: self.date, subtitle: response.subtitle, changed: response.changed ?? false, standinDayId: standinDay, blocks: blocks)
		return daySchedule
	}

}

struct GetPatchResponse: WebCallPayload
{
	var subtitle: String?
	var blocks: [GetPatchResponseBlock]
	var changed: Bool?
	var replaceDayId: Int?
	
	init(unboxer: Unboxer) throws
	{
		self.subtitle = unboxer.unbox(key: "subtitle")
		self.changed = unboxer.unbox(key: "changed")
		self.blocks = try unboxer.unbox(keyPath: "blocks", allowInvalidElements: false)
		self.replaceDayId = unboxer.unbox(key: "standin-day")
	}
}

struct GetPatchResponseBlock: WebCallPayload
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
		
		self.customName = unboxer.unbox(key: "name")
	}
}
