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
		let view = AttachmentView()
		
		view.text = "Special schedule"
		
		view.style = .RED
		view.leftImage = UIImage(named: "icon_clock")
		
//		view.showDisclosure = true
//		view.enableClicks()
		
		return view
	}
	
}

class ScheduleNoticeUpcomingItem: UpcomingItem {
	
	let notice: DateNotice
	
	init(notice: DateNotice, date: Date) {
		self.notice = notice
		
		super.init(type: .scheduleNotice, date: date)
	}
	
	override func generateAttachmentView() -> AttachmentView {
		let view = AttachmentView()
		
		view.text = "\(self.notice.priority.displayName): \(self.notice.message)"
		
		view.style = .ORANGE
		view.leftImage = UIImage(named: "icon_danger")
		
//		view.showDisclosure = true
//		view.enableClicks()
		
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
		let view = AttachmentView()
		
		view.text = "\(self.event.completeDescription())"
		
		view.style = .YELLOW
		view.leftImage = UIImage(named: "icon_alert")
		
//		view.showDisclosure = true
//		view.enableClicks()
		
		return view
	}
	
}
