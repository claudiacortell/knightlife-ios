//
//  SpecialSchedulesWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class SpecialSchedulesWebCall: UnboxWebCall<KnightlifeListPayload<SpecialSchedulePayload>, [Schedule]> {
	
	init(date: Date) {
		super.init(call: "schedule/special")
		
		self.parameter("date", val: date.webSafeDate)
	}
	
	override func convertToken(_ data: KnightlifeListPayload<SpecialSchedulePayload>) -> [Schedule]? {
		guard let content = data.content else {
			return nil
		}
		
		var schedules: [Schedule] = []
		for dayPayload in content {
			guard let date = Date.fromWebDate(string: dayPayload.date) else {
				continue
			}
			
			var blocks: [Block] = []
			
			for responseBlock in dayPayload.blocks {
				guard let id = Block.ID(rawValue: responseBlock.id) else {
					print("Invalid block id: \(responseBlock.id)")
					continue
				}
				
				guard let start = Date.fromWebTime(string: responseBlock.start), let end = Date.fromWebTime(string: responseBlock.end) else {
					print("Failed to parse a date.")
					continue
				}
				
				guard let adjustedStart = Date.mergeDateAndTime(date: date, time: start), let adjustedEnd = Date.mergeDateAndTime(date: date, time: end) else {
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
				if let responseDay = dayPayload.day {
					return DayOfWeek.fromShortName(shortName: responseDay)
				}
				return nil
			}()
			
			let notices: [DateNotice] = dayPayload.notices == nil ? [] : {
				var list: [DateNotice] = []
				for responseNotice in dayPayload.notices! {
					guard let priority = DateNoticePriority(rawValue: responseNotice.priority) else {
						print("Recieved an invalid notice priority: \(responseNotice.priority)")
						continue
					}
					
					list.append(DateNotice(priority: priority, message: responseNotice.message))
				}
				return list
			}()
			
			let daySchedule = Schedule(date: date, day: day, changed: dayPayload.changed ?? false, notices: notices, blocks: blocks)
			schedules.append(daySchedule)
		}
		return schedules
	}
	
}

class SpecialSchedulePayload: PatchDatePayload {
	
	let date: String
	
	required init(unboxer: Unboxer) throws {
		self.date = try unboxer.unbox(key: "date")
		
		try super.init(unboxer: unboxer)
	}
	
}
