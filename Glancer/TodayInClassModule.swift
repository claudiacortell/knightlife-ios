//
//  TodayInClassModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class TodayInClassModule: TableModule {
	
	let controller: DayController
	let bundle: DayBundle
	let current: Block
	let next: Block?
	let minutesLeft: Int
	
	init(controller: DayController, bundle: DayBundle, current: Block, next: Block?, minutesLeft: Int) {
		self.controller = controller
		self.bundle = bundle
		self.current = current
		self.next = next
		self.minutesLeft = minutesLeft
		
		super.init()
	}
	
	override func build() {
		let analyst = BlockAnalyst(schedule: bundle.schedule, block: current)
		
		let todaySection = self.addSection()
		todaySection.addCell(TodayStatusCell(state: "in \(analyst.getDisplayName())", minutes: self.minutesLeft, image: UIImage(named: "icon_clock")!, color: analyst.getColor()))
		
		let secondPassed = Calendar.normalizedCalendar.dateComponents([.second], from: current.time.start, to: Date.today).second!
		let secondDuration = Calendar.normalizedCalendar.dateComponents([.second], from: current.time.start, to: current.time.end).second!
		
		let duration = Float(secondPassed) / Float(secondDuration)
		
		todaySection.addCell(TodayBarCell(color: analyst.getColor(), duration: duration))
		
		self.addModule(BlockListModule(controller: self.controller, bundle: self.bundle, title: nil, blocks: [ self.current ], options: [ .bottomBorder ]))
		
		let section = self.addSection()
		section.addSpacerCell().setHeight(30)
		
		let upcomingBlocks = self.bundle.schedule.getBlocksAfter(self.current)
		self.addModule(BlockListModule(controller: self.controller, bundle: self.bundle, title: nil, blocks: upcomingBlocks, options: [ .topBorder, .bottomBorder ]))
		
		if upcomingBlocks.isEmpty {
			self.addModule(AfterSchoolEventsModule(bundle: self.bundle, title: "After School", options: [ .bottomBorder, .topBorder ]))
		} else {
			self.addModule(AfterSchoolEventsModule(bundle: self.bundle, title: "After School", options: [ .bottomBorder ]))
		}
		
		self.addSection().addSpacerCell().setHeight(35)

	}
	
}
