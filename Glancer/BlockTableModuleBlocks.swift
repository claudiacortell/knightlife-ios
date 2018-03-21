//
//  BlockTableModuleBlcoks.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockTableModuleBlocks: TableModule
{
	let controller: BlockTableViewController
	
	init(controller: BlockTableViewController)
	{
		self.controller = controller
	}
	
	func generateSections(container: TableContainer)
	{
		let section = container.newSection()
		section.headerHeight = 1
		
		for block in self.controller.daySchedule!.getBlocks() // Testing variations
		{
			let cell = TableCell("block", callback:
			{ templateCell, cell in
				if self.controller.daySchedule != nil, self.controller.daySchedule!.hasBlock(block), let viewCell = cell as? BlockTableBlockViewCell, let block = templateCell.getData("block") as? ScheduleBlock
				{
					viewCell.block = block
		
					let analyst = BlockAnalyst(block, schedule: self.controller.daySchedule!)
					viewCell.blockName = analyst.getDisplayName()
					viewCell.blockLetter = analyst.getDisplayLetter()
					viewCell.color = analyst.getColor()
		
					viewCell.time = block.time
				}
			})
			cell.setData("block", data: block)
			cell.setHeight(65)
			section.addCell(cell)
		}
	}
}
