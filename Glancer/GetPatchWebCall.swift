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
		
		let item = response.item
		for responseBlock in item.blocks {
			guard let id = BlockID.fromStringValue(name: responseBlock.id) else {
				print("Invalid block id: \(responseBlock.id)")
				continue
			}
			
			guard let start = Date.fromWebTime(string: responseBlock.start), let end = Date.fromWebTime(string: responseBlock.end) else {
				print("Failed to parse a date.")
				continue
			}
			
			guard let adjustedStart = Date.mergeDateAndTime(date: self.date, time: start), let adjustedEnd = Date.mergeDateAndTime(date: self.date, time: end) else {
				print("Failed to join date and time.")
				continue
			}
			
			let duration = TimeDuration(start: adjustedStart, end: adjustedEnd)
			let custom: CustomBlockMeta? = {
				if let responseCustom = responseBlock.custom {
					return CustomBlockMeta(name: responseCustom.name, color: UIColor(hex: responseCustom.color) ?? UIColor.black)
				}
				return nil
			}()
			
			blocks.append(Block(id: id, variation: responseBlock.variation, time: duration, custom: custom))
		}
		
		let day: DayOfWeek? = {
			if let responseDay = item.day {
				return DayOfWeek.fromShortName(shortName: responseDay)
			}
			return nil
		}()
		
		let notices: [DateNotice] = item.notices == nil ? [] : {
			var list: [DateNotice] = []
			for responseNotice in item.notices! {
				list.append(DateNotice(priority: responseNotice.priority, message: responseNotice.message))
			}
			return list
		}()
		
		let daySchedule = DateSchedule(date: self.date, day: day, changed: item.changed ?? false, notices: notices, blocks: blocks)
		return daySchedule
	}

}

struct GetPatchResponse: WebCallPayload {
	
	let item: PatchDatePayload
	
	init(unboxer: Unboxer) throws {
		self.item = try unboxer.unbox(key: "item")
	}
	
}

class PatchDatePayload: DayPayload {
	
	let day: String?
	
	required init(unboxer: Unboxer) throws {
		self.day = unboxer.unbox(key: "day")
		
		try super.init(unboxer: unboxer)
	}
	
}
