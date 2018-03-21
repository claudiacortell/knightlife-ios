//
//  BlockTableModuleToday.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class BlockTableModuleToday: TableModule
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
		
		section.addSpacerCell(15)
		
		section.addCell("today_now").setHeight(35)
		section.addCell("today_next").setHeight(25)

		section.addSpacerCell(10)

		section.addCell("today_now_label").setHeight(20)
		section.addCell("today_progress").setHeight(3)
	
		
		section.addSpacerCell(15)
	}
}
