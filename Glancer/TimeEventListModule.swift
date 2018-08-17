//
//  TimeEventListModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/14/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class TimeEventListModule: TableModule {
	
	let events: [TimeEvent]
	let title: String?
	
	init(events: [TimeEvent], title: String? = nil) {
		self.events = events
		self.title = title
	}
	
	override func build() {
		let section = self.addSection()
		
		section.addCell(TitleCell(title: self.title ?? "After School"))
		section.addDivider()
		
		for event in self.events {
			let view = TimeEventAttachmentView()
			view.event = event
			
			section.addCell(AttachmentCell(attachmentViews: [view], selectable: false))
			section.addDivider()
		}

	}
	
}
