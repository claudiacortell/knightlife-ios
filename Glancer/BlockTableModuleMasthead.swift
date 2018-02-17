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
		let mainSection = TableSection()
		mainSection.addSpacerCell(20) // Header.
		
		mainSection.addCell(TableCell("masthead.scope", callback:
		{ viewCell, cell in
			if let blockCell = cell as? BlockTableTextViewCell
			{
				if TimeUtils.isToday(self.controller.date)
				{
					blockCell.textBox = "TODAY"
				} else if TimeUtils.isTomorrow(self.controller.date)
				{
					blockCell.textBox = "TOMORROW"
				} else
				{
					blockCell.textBox = "\(TimeUtils.daysUntil(self.controller.date)) DAYS AWAY"
				}
			}
		}))
		
		mainSection.addCell(TableCell("masthead.date", callback:
		{ viewCell, cell in
			(cell as! BlockTableTextViewCell).textBox = self.controller.date.prettyString
		}))
		
		if self.controller.daySchedule != nil
		{
			if let subtitle = self.controller.daySchedule?.subtitle
			{
				mainSection.addCell(TableCell("masthead.emphasis", callback:
				{ viewCell, cell in
					(cell as! BlockTableTextViewCell).textBox = subtitle
				}))
			}
			
			mainSection.addSpacerCell(10)
			container.addSection(mainSection)
			
			if let first = self.controller.daySchedule!.getFirstBlock(), let last = self.controller.daySchedule!.getLastBlock()
			{
				let subtitleSection = TableSection()

				subtitleSection.addCell(TableCell("masthead.subtitle", callback:
				{ viewCell, cell in
					(cell as! BlockTableTextViewCell).textBox = "\(first.time.startTime.toString()) - \(last.time.endTime.toString())"
				}))
				
				subtitleSection.addCell(TableCell("masthead.subtitle", callback:
				{ viewCell, cell in
					(cell as! BlockTableTextViewCell).textBox = "\(self.controller.daySchedule!.getBlocks().count) Blocks"
				}))
				
				subtitleSection.addSpacerCell(15)
				container.addSection(subtitleSection)
			}
			
			if self.controller.daySchedule!.changed
			{
				let changedSection = TableSection()
				changedSection.addCell(TableCell("masthead.changed"))
				changedSection.addSpacerCell(15)
				container.addSection(changedSection)
			}
		} else
		{
			mainSection.addSpacerCell(10)
			container.addSection(mainSection)
		}
	}
}
