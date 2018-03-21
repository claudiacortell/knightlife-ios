//
//  BlockTableModuleMasthead.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class BlockTableModuleMasthead: TableModule
{
	let controller: BlockTableViewController
		
	init(controller: BlockTableViewController)
	{
		self.controller = controller
	}
	
	func generateSections(container: TableContainer)
	{
		let section = container.newSection()
		section.addSpacerCell(15)

		if self.controller.daySchedule != nil
		{
			if self.controller.daySchedule!.changed
			{
				section.addCell("masthead_changed")
				section.addSpacerCell(5)
			}
		}
		
		section.addCell(TableCell("masthead_date", callback:
		{ viewCell, cell in
			if let blockCell = cell as? BlockTableTextViewCell
			{
				if TimeUtils.isToday(self.controller.date)
				{
					blockCell.textBox = "Today"
				} else if TimeUtils.isTomorrow(self.controller.date)
				{
					blockCell.textBox = "Tomorrow"
				} else if TimeUtils.wasYesterday(self.controller.date)
				{
					blockCell.textBox = "Yesterday"
				} else
				{
					blockCell.textBox = self.controller.date.prettyString
				}
			}
		}))
		
		if self.controller.daySchedule != nil
		{
			if let subtitle = self.controller.daySchedule?.subtitle
			{
				section.addCell(TableCell("masthead_subtitle", callback:
				{ viewCell, cell in
					(cell as! BlockTableTextViewCell).textBox = subtitle
				}))
			}
		}
		
		section.addSpacerCell(15)
		
		if let _ = self.controller.lunchMenu
		{
			let cell = TableCell("masthead_lunch")
			cell.height = 40;
			section.addCell(cell)
			section.addSpacerCell(10)
		}
	}
}
