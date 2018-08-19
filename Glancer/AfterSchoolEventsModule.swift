//
//  AfterSchoolEventsModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class AfterSchoolEventsModule: TableModule {
	
	let events: [TimeEvent]
	let title: String
	let options: [DayModuleOptions]
	
	init(bundle: DayBundle, title: String, options: [DayModuleOptions]) {
		self.events = bundle.events.getOutOfSchoolEvents()
		self.title = title
		self.options = options
		
		super.init()
	}
	
	override func build() {
		if self.events.isEmpty {
			return
		}
		
		let section = self.addSection()
		
		if self.options.contains(.topBorder) { section.addDivider() }
		section.addCell(TitleCell(title: self.title))
		section.addDivider()
		
		for i in 0..<self.events.count {
			let event = self.events[i]
			
			let view = TimeEventAttachmentView()
			view.event = event
			
			section.addCell(AttachmentCell(attachmentViews: [view], selectable: false))

			if i == self.events.count - 1 { // Last
				if self.options.contains(.bottomBorder) { section.addDivider() }
			} else {
				section.addDivider()
			}
		}
	}
	
}
