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
	
	let composites: [CompositeBlock]
	
	init(composites: [CompositeBlock]) {
		self.composites = composites
	}
	
	func loadCells(layout: TableLayout) {
		let section = layout.addSection()
		section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		
		for composite in self.composites {
			section.addCell(BlockCell(composite: composite))
			section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		}
	}
	
}
