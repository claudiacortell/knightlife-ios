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
	
	let section: TableSection?
	let events: [TimeEvent]
	let title: String?
	
	init(events: [TimeEvent], section: TableSection? = nil, title: String? = nil) {
		self.events = events
		self.section = section
		self.title = title
	}
	
	func loadCells(layout: TableLayout) {
		let section = self.section ?? layout.addSection()
		
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
