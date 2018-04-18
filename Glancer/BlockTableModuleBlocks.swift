//
//  BlockTableModuleBlcoks.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Charcore

class BlockTableModuleBlocks: TableModule
{
	let controller: BlockViewController
	
	init(controller: BlockViewController)
	{
		self.controller = controller
	}
	
	func loadCells(form: TableForm) {
		let section = form.addSection().setHeaderHeight(1)
		section.addSpacerCell().setHeight(3)
		
		for block in self.controller.daySchedule!.getBlocks() // Testing variations
		{
			let cell = section.addCell("block")
			cell.setHeight(65)
			cell.setMetadata("block", value: block)
			cell.setCallback({
				template, cell in
				
				if self.controller.daySchedule != nil, self.controller.daySchedule!.hasBlock(block), let viewCell = cell as? BlockTableBlockViewCell, let block = template.getMetadata("block") as? ScheduleBlock {
					viewCell.block = block
					
					let analyst = BlockAnalyst(block, schedule: self.controller.daySchedule!)
					viewCell.blockName = analyst.getDisplayName()
					viewCell.blockLetter = analyst.getDisplayLetter()
					viewCell.color = analyst.getColor()
					
					viewCell.time = block.time
				}
			})
		}
		
		section.addSpacerCell().setHeight(10)
	}
}
