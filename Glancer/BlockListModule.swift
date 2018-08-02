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
	
	let section: TableSection?
	let controller: DayController
	let composites: [CompositeBlock]
	
	init(controller: DayController, composites: [CompositeBlock], section: TableSection? = nil) {
		self.controller = controller
		self.composites = composites
		self.section = section
	}
	
	func loadCells(layout: TableLayout) {
		let section = self.section ?? layout.addSection()
		
		if !self.composites.isEmpty {
			section.addDivider()
		}
		
		for composite in self.composites {
			section.addCell(BlockCell(controller: self.controller, composite: composite))
			section.addDivider()
		}
	}
	
}
