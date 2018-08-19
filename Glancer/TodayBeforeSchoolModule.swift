//
//  TodayBeforeSchoolModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class TodayBeforeSchoolModule: TableModule {
	
	let controller: DayController
	let today: DayBundle
	let firstBlock: Block
	let minutesUntil: Int
	
	init(controller: DayController, today: DayBundle, firstBlock: Block, minutesUntil: Int) {
		self.controller = controller
		self.today = today
		self.firstBlock = firstBlock
		self.minutesUntil = minutesUntil
		
		super.init()
	}
	
	override func build() {
		self.addSection().addCell(TodayStatusCell(state: "Before School", minutes: self.minutesUntil, image: UIImage(named: "icon_clock")!, color: UIColor.black.withAlphaComponent(0.3)))
		
		let upcomingBlocks = self.today.schedule.getBlocks()
		self.addModule(BlockListModule(controller: self.controller, bundle: self.today, title: nil, blocks: upcomingBlocks, options: [ .topBorder, .bottomBorder ]))
		
		self.addModule(AfterSchoolEventsModule(bundle: self.today, title: "After School", options: [ .bottomBorder ]))
		
		self.addSection().addSpacerCell().setHeight(35)
	}
	
}
