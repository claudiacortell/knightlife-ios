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
	let composites: [CompositeBlock]
	
	init(controller: DayController, composites: [CompositeBlock]) {
		self.controller = controller
		self.composites = composites
		
		super.init()
	}
	
	override func build() {
		let section = self.addSection()

		for composite in self.composites {
			section.addCell(BlockCell(controller: self.controller, composite: composite))
			section.addDivider()
		}		
	}
	
}
