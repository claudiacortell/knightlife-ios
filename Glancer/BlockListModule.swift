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
	
	let schedule: DateSchedule
	let blocks: [Block]
	
	init(schedule: DateSchedule, blocks: [Block]) {
		self.schedule = schedule
		self.blocks = blocks
	}
	
	func loadCells(layout: TableLayout) {
		let section = layout.addSection()
		section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		
		for block in self.blocks {
			section.addCell(BlockCell(schedule: self.schedule, block: block))
			section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		}
	}
	
}
