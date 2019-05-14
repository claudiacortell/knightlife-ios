//
//  UpcomingItem.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/11/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

enum UpcomingItemType: String {
	
	case scheduleChanged = "schedule"
	case scheduleNotice = "notice"
	case event = "event"
	
}

class UpcomingItem {
	
	let type: UpcomingItemType
	let date: Date
	
	init(type: UpcomingItemType, date: Date) {
		self.type = type
		self.date = date
	}
	
	// Override
	func generateAttachmentView() -> AttachmentView {
		return AttachmentView()
	}
	
}

class ScheduleChangedUpcomingItem: UpcomingItem {
	
	init(date: Date) {
		super.init(type: .scheduleChanged, date: date)
	}
	
	override func generateAttachmentView() -> AttachmentView {
		return ScheduleChangedAttachment()
	}
	
}

class ScheduleNoticeUpcomingItem: UpcomingItem {
	
	let notice: DateNotice
	
	init(notice: DateNotice, date: Date) {
		self.notice = notice
		
		super.init(type: .scheduleNotice, date: date)
	}
	
	override func generateAttachmentView() -> AttachmentView {
		let view = NoticeAttachmentView()
		view.notice = notice
		return view
	}
	
}

class EventUpcomingItem: UpcomingItem {
	
	let event: Event
	
	init(event: Event, date: Date) {
		self.event = event
		
		super.init(type: .event, date: date)
	}
	
	override func generateAttachmentView() -> AttachmentView {
		if self.event.schedule.usesTime {
			let view = TimeEventAttachmentView()
			view.event = self.event
			return view
		} else {
			let view = EventAttachmentView()
			view.event = self.event
			return view
		}
	}
	
}
