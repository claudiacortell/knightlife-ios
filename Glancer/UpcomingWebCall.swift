//
//  UpcomingWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/11/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class UpcomingWebCall: UnboxWebCall<KnightlifeListPayload<UpcomingPayload>, [(Date, [UpcomingItem])]> {
	
	init(date: Date) {
		super.init(call: "upcoming")
		
		self.parameter("date", val: date.webSafeDate)
	}
	
	override func convertToken(_ data: KnightlifeListPayload<UpcomingPayload>) -> [(Date, [UpcomingItem])]? {
		guard let content = data.content else {
			return nil
		}
		
		var items: [UpcomingItem] = [] // Put them all in a list first because it's easier to deal with
		
		for payload in content {
			guard let date = Date.fromWebDate(string: payload.date) else {
				print("Invalid date given: \(payload.date)")
				continue
			}
			
			let type = UpcomingItemType(rawValue: payload.type)! // We can force unwrap because it was already unwrapped in the payload
			
			switch type {
			case .scheduleChanged:
				items.append(ScheduleChangedUpcomingItem(date: date))
			case .scheduleNotice:
				if let notice = self.convert(noticePayload: payload.data as! DayNoticePayload) {
					items.append(ScheduleNoticeUpcomingItem(notice: notice, date: date))
				}
			case .event:
				if let event = self.convert(eventPayload: payload.data as! EventPayload) {
					items.append(EventUpcomingItem(event: event, date: date))
				}
			}
		}
	
		var sortedItems: [Date: [UpcomingItem]] = [:]
		for item in items {
			if sortedItems[item.date] == nil { sortedItems[item.date] = [] }
			sortedItems[item.date]!.append(item)
		}
		
		return sortedItems.sorted(by: { $0.key < $1.key })
	}
	
	private func convert(noticePayload: DayNoticePayload) -> DateNotice? {
		guard let priority = DateNoticePriority(rawValue: noticePayload.priority) else {
			print("Invalid priority given: \(noticePayload.priority)")
			return nil
		}
		
		return DateNotice(priority: priority, message: noticePayload.message)
	}
	
	private func convert(eventPayload: EventPayload) -> Event? {
		guard let blockId = BlockID.fromStringValue(name: eventPayload.block) else {
			print("Wasn't able to parse event block: \(eventPayload.block)")
			return nil
		}
		
		var audience: [EventAudience] = []
		for group in eventPayload.audience {
			guard let grade = Grade(rawValue: group.id) else {
				print("Invalid grade supplied: \(group.id)")
				continue
			}
			
			audience.append(EventAudience(grade: grade, mandatory: group.mandatory))
		}
		
		return Event(block: blockId, description: eventPayload.description, audience: audience)
	}
	
}

class UpcomingPayload: WebCallPayload {
	
	let date: String
	let type: String
	let data: Any?
	
	required init(unboxer: Unboxer) throws {
		self.date = try unboxer.unbox(key: "date")
		self.type = try unboxer.unbox(key: "upcomingType")
		
		guard let payloadType = UpcomingItemType(rawValue: self.type) else {
			throw UnboxError.invalidData
		}
		
		switch payloadType {
		case .scheduleChanged:
			self.data = nil
		case .scheduleNotice:
			let noticePayload: DayNoticePayload = try unboxer.unbox(key: "data")
			self.data = noticePayload
		case .event:
			let eventPayload: EventPayload = try unboxer.unbox(key: "data")
			self.data = eventPayload
		}
	}
	
}
