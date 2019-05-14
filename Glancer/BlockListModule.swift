//
//  BlockListModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/26/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class BlockListModule: TableModule {
	
	let controller: DayController
	
	let title: String?
	
	let bundle: DayBundle
	let blocks: [Block]
	
	let options: [DayModuleOptions]
	
	init(controller: DayController, bundle: DayBundle, title: String?, blocks: [Block], options: [DayModuleOptions] = []) {
		self.controller = controller
		
		self.title = title
		
		self.bundle = bundle
		self.blocks = blocks
		
		self.options = options
		
		super.init()
	}
	
	override func build() {
		if self.blocks.isEmpty {
			return
		}
		
		let section = self.addSection()
		
		if self.options.contains(.topBorder) { section.addDivider() }
		
		if let title = self.title {
			section.addCell(TitleCell(title: title))
			section.addDivider()
		}
		
		for block in self.blocks {
			let composite = CompositeBlock(schedule: self.bundle.schedule, block: block, lunch: (block.id == .lunch && !self.bundle.menu.items.isEmpty ? bundle.menu : nil), events: self.bundle.events.eventsFor(block: block.id))
			
			section.addCell(BlockCell(controller: self.controller, composite: composite))
			
			if self.blocks.last == block {
				if self.options.contains(.bottomBorder) { section.addDivider() }
			} else {
				section.addDivider()
			}
		}
	}
	
}

struct CompositeBlock {
	
	let schedule: DateSchedule
	let block: Block
	
	let lunch: Lunch?
	let events: [Event]
	
}
