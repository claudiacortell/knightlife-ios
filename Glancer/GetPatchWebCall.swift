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

class GetPatchWebCall: UnboxWebCall<KnightlifePayload<PatchDatePayload>, DateSchedule> {
	
	let date: Date
	
	init(date: Date) {
		self.date = date
		
		super.init(call: "schedule")
		
		self.parameter("date", val: date.webSafeDate)
	}
	
	override func convertToken(_ response: KnightlifePayload<PatchDatePayload>) -> DateSchedule? {
		guard let content = response.content else {
			return nil
		}
		
		var blocks: [Block] = []
		
		for responseBlock in content.blocks {
			guard let id = Block.ID(rawValue: responseBlock.id) else {
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
					return CustomBlockMeta(name: responseCustom.name, color: UIColor(hex: responseCustom.color) ?? Scheme.darkText.color, location: responseCustom.location)
				}
				return nil
			}()
			
			blocks.append(Block(id: id, variation: responseBlock.variation, time: duration, custom: custom))
		}
		
		let day: DayOfWeek? = {
			if let responseDay = content.day {
				return DayOfWeek.fromShortName(shortName: responseDay)
			}
			return nil
		}()
		
		let notices: [DateNotice] = content.notices == nil ? [] : {
			var list: [DateNotice] = []
			for responseNotice in content.notices! {
				guard let priority = DateNoticePriority(rawValue: responseNotice.priority) else {
					print("Recieved an invalid notice priority: \(responseNotice.priority)")
					continue
				}
				
				list.append(DateNotice(priority: priority, message: responseNotice.message))
			}
			return list
		}()
		
		let daySchedule = DateSchedule(date: self.date, day: day, changed: content.changed ?? false, notices: notices, blocks: blocks)
		return daySchedule
	}

}

class PatchDatePayload: DayPayload {
	
	let day: String?
	
	required init(unboxer: Unboxer) throws {
		self.day = unboxer.unbox(key: "day")
		
		try super.init(unboxer: unboxer)
	}
	
}
